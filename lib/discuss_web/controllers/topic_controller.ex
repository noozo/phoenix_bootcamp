defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  plug DiscussWeb.Plugs.RequireAuth when action not in [:index, :show]

  def index(conn, _params) do
    render(conn, "index.html", topics: Repo.all(Topic))
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    render(conn, "new.html", changeset: Topic.changeset(%Topic{}, %{}))
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"topic" => attributes}) do
    changeset = Topic.changeset(%Topic{}, attributes)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Repo.get(Topic, id)

    render(conn, "edit.html", changeset: Topic.changeset(topic), topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => attributes}) do
    topic = Repo.get(Topic, id)
    changeset = Topic.changeset(topic, attributes)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", topic: Repo.get(Topic, id))
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Topic, id) |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
