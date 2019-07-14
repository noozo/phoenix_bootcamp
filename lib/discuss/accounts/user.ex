defmodule Discuss.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Discuss.Discussions.{Topic, Comment}

  @derive {Jason.Encoder, only: [:email, :name]}

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Topic
    has_many :comments, Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :name, :provider, :token])
    |> validate_required([:email, :name, :provider, :token])
  end
end
