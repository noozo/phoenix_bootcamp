defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Repo
  alias Discuss.User

  # NOTE: Return of this function is passed to the call function
  def init(default), do: default

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        # conn.assigns.user -> user struct
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
