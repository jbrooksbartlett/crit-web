defmodule CritWeb.Plugs.Identity do
  @moduledoc """
  Ensures every browser session has an anonymous identity UUID.
  The identity is stored in the session and used to attribute comments.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if get_session(conn, "identity") do
      conn
    else
      put_session(conn, "identity", Ecto.UUID.generate())
    end
  end
end
