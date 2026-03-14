defmodule CritWeb.HealthControllerTest do
  use CritWeb.ConnCase

  test "GET /health returns 200", %{conn: conn} do
    conn = get(conn, "/health")
    assert json_response(conn, 200) == %{"status" => "ok"}
  end
end
