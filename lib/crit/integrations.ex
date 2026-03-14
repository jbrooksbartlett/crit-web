defmodule Crit.Integrations do
  @moduledoc """
  Fetches integration snippets from GitHub at compile time and caches them in priv/integrations/.

  The crit repo's `integrations/` directory is the source of truth.
  Cached files are used on subsequent compiles. Run `mix crit.refresh_integrations`
  or delete `priv/integrations/` to force a re-fetch.
  """

  @github_base "https://raw.githubusercontent.com/tomasz-tomczyk/crit/main/integrations/"
  @cache_dir Path.join(:code.priv_dir(:crit) |> to_string(), "integrations")

  @doc """
  Called at compile time from PageController. Takes integration metadata,
  fetches snippet content from GitHub (or cache), and returns enriched maps.
  """
  def load(meta_list) do
    File.mkdir_p!(@cache_dir)

    Enum.map(meta_list, fn meta ->
      snippet = fetch(meta.source)

      meta
      |> Map.put(:snippet, snippet)
      |> maybe_add_secondary()
    end)
  end

  defp maybe_add_secondary(%{secondary_source: source} = meta) do
    Map.put(meta, :secondary_snippet, fetch(source))
  end

  defp maybe_add_secondary(meta), do: meta

  defp fetch(source_path) do
    cache_path = Path.join(@cache_dir, source_path |> String.replace("/", "--"))

    case File.read(cache_path) do
      {:ok, content} ->
        content

      {:error, _} ->
        content = fetch_from_github(source_path)
        File.mkdir_p!(Path.dirname(cache_path))
        File.write!(cache_path, content)
        content
    end
  end

  defp fetch_from_github(source_path) do
    url = @github_base <> source_path

    case fetch_url(url) do
      {:ok, body} ->
        body

      {:error, reason} ->
        raise """
        Failed to fetch integration file from GitHub: #{url}
        Reason: #{inspect(reason)}

        If you're offline, populate the cache manually:
          mkdir -p priv/integrations
          curl -o priv/integrations/#{source_path |> String.replace("/", "--")} #{url}
        """
    end
  end

  defp fetch_url(url) do
    # Ensure ssl and inets are started for :httpc
    Application.ensure_all_started(:ssl)
    Application.ensure_all_started(:inets)

    url_charlist = String.to_charlist(url)

    case :httpc.request(:get, {url_charlist, []}, [ssl: ssl_opts()], []) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        {:ok, List.to_string(body)}

      {:ok, {{_, status, _}, _headers, _body}} ->
        {:error, "HTTP #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp ssl_opts do
    [
      verify: :verify_peer,
      cacerts: :public_key.cacerts_get(),
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]
  end
end
