defmodule CritWeb.HealthController do
  use CritWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
