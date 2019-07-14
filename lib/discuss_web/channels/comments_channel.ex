defmodule DiscussWeb.CommentsChannel do
  use Phoenix.Channel
  alias Discuss.Repo
  alias Discuss.Discussions.{Topic, Comment}

  def join("comments:" <> topic_id, _message, socket) do
    topic_id = topic_id |> String.to_integer()

    topic =
      Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user])

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in("comments:create", %{"content" => content}, socket) do
    topic = socket.assigns.topic
    IO.inspect(socket.assigns)
    user_id = socket.assigns.user_id

    changeset =
      topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:created", %{comment: comment})
        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
