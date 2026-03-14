defmodule CritWeb.AuthControllerTest do
  use CritWeb.ConnCase, async: true

  setup do
    Application.put_env(:crit, :admin_password, "test-password-123")
    on_exit(fn -> Application.delete_env(:crit, :admin_password) end)
  end

  describe "POST /auth/login" do
    test "sets session on correct password", %{conn: conn} do
      conn = post(conn, ~p"/auth/login", %{"password" => "test-password-123"})

      assert redirected_to(conn) == ~p"/dashboard"
      assert get_session(conn, :admin_authenticated) == true
    end

    test "shows error on wrong password", %{conn: conn} do
      conn = post(conn, ~p"/auth/login", %{"password" => "wrong"})

      assert redirected_to(conn) == ~p"/dashboard"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Invalid password"
      refute get_session(conn, :admin_authenticated)
    end
  end

  describe "POST /auth/logout" do
    test "clears session", %{conn: conn} do
      conn =
        conn
        |> init_test_session(%{admin_authenticated: true})
        |> post(~p"/auth/logout")

      assert redirected_to(conn) == ~p"/dashboard"
      refute get_session(conn, :admin_authenticated)
    end
  end
end
