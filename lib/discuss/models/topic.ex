defmodule Discuss.Topic do
  use Ecto.Schema
  require Ecto.Query

  alias Discuss.Topic
  alias Discuss.Repo

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
  end

  def where(params) do
    Topic
    |> Ecto.Query.where(^params)
    |> Repo.all()
  end

  def changeset(topic, params \\ %{}) do
    topic
    |> Ecto.Changeset.cast(params, [:title, :user_id])
    |> Ecto.Changeset.validate_required([:title, :user_id])
  end
end
