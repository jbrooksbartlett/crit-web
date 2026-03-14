defmodule CritWeb.Plugs.LocalhostCors do
  @moduledoc """
  Reflects CORS headers for requests originating from localhost or 127.0.0.1
  (any port). Used on POST /api/reviews so the local Crit binary can upload
  reviews from its embedded browser / from the user's browser on localhost.
  Handles OPTIONS preflight inline.
  """
  import Plug.Conn

  @localhost ~r/^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/

  def init(opts), do: opts

  def call(conn, _opts) do
    origin = conn |> get_req_header("origin") |> List.first()

    conn =
      if origin && Regex.match?(@localhost, origin) do
        conn
        |> put_resp_header("access-control-allow-origin", origin)
        |> put_resp_header("access-control-allow-methods", "POST, DELETE, OPTIONS")
        |> put_resp_header("access-control-allow-headers", "content-type")
        |> put_resp_header("access-control-max-age", "86400")
        |> put_resp_header("vary", "Origin")
      else
        conn
      end

    if conn.method == "OPTIONS" do
      conn |> send_resp(204, "") |> halt()
    else
      conn
    end
  end
end
