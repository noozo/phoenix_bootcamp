defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias DiscussWeb.Router.Helpers

  # NOTE: Return of this function is passed to the call function
  def init(default), do: default

  def call(conn, _default) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end

    # TODO: Try with pattern matching
  end
end
