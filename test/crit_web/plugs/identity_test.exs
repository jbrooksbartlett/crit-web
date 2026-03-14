defmodule CritWeb.Plugs.IdentityTest do
  use CritWeb.ConnCase, async: true

  describe "identity plug" do
    test "assigns identity to session when none exists", %{conn: conn} do
      conn = get(conn, ~p"/")
      identity = get_session(conn, "identity")
      assert identity != nil
      assert {:ok, _} = Ecto.UUID.cast(identity)
    end

    test "preserves existing identity across requests", %{conn: conn} do
      conn1 = get(conn, ~p"/")
      identity1 = get_session(conn1, "identity")

      conn2 =
        conn1
        |> recycle()
        |> get(~p"/")

      identity2 = get_session(conn2, "identity")
      assert identity1 == identity2
    end
  end
end
