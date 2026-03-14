defmodule CritWeb.AuthController do
  use CritWeb, :controller

  def login(conn, %{"password" => password}) do
    stored = Application.get_env(:crit, :admin_password)

    if stored && Plug.Crypto.secure_compare(password, stored) do
      conn
      |> configure_session(renew: true)
      |> put_session(:admin_authenticated, true)
      |> redirect(to: ~p"/dashboard")
    else
      conn
      |> put_flash(:error, "Invalid password.")
      |> redirect(to: ~p"/dashboard")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:admin_authenticated)
    |> redirect(to: ~p"/dashboard")
  end
end
