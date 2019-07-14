defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Discussions
  alias Discuss.Discussions.Topic
  alias DiscussWeb.Router.Helpers

  plug DiscussWeb.Plugs.RequireAuth when action not in [:index, :show]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    render(conn, "index.html", topics: Discussions.list_topics())
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    render(conn, "new.html", changeset: Topic.changeset(%Topic{}, %{}))
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"topic" => attributes}) do
    case Discussions.create_topic(attributes, conn.assigns.user) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Discussions.get_topic!(id)

    render(conn, "edit.html", changeset: Topic.changeset(topic), topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => attributes}) do
    topic = Discussions.get_topic!(id)

    case Discussions.update_topic(topic, attributes) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", topic: Discussions.get_topic!(id))
  end

  def delete(conn, %{"id" => id}) do
    Discussions.get_topic!(id) |> Discussions.delete_topic()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _default) do
    if Discussions.get_topic!(topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "That topic does not belong to you")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end
  end
end
