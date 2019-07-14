defmodule Discuss.Discussions.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.Accounts.User
    has_many :comments, Discuss.Discussions.Comment
  end

  @doc false
  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
