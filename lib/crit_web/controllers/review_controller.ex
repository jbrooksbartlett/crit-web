defmodule CritWeb.ReviewController do
  use CritWeb, :controller

  def set_name(conn, %{"name" => name}) do
    case Crit.DisplayName.normalize(name) do
      nil -> conn |> put_status(422) |> json(%{error: "name cannot be blank"})
      name -> conn |> put_session("display_name", name) |> json(%{ok: true})
    end
  end

  def set_name(conn, _params) do
    conn |> put_status(422) |> json(%{error: "name is required"})
  end
end
