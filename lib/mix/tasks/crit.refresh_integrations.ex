defmodule Mix.Tasks.Crit.RefreshIntegrations do
  @shortdoc "Re-fetch integration snippets from GitHub"
  @moduledoc "Deletes cached integration files and forces a fresh fetch on next compile."

  use Mix.Task

  @impl true
  def run(_args) do
    cache_dir = Path.join(:code.priv_dir(:crit) |> to_string(), "integrations")

    if File.dir?(cache_dir) do
      File.rm_rf!(cache_dir)
      Mix.shell().info("Cleared integration cache at #{cache_dir}")
    else
      Mix.shell().info("No integration cache found at #{cache_dir}")
    end

    Mix.shell().info("Run `mix compile --force` to re-fetch from GitHub")
  end
end
