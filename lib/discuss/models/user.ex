defmodule Discuss.User do
  use Ecto.Schema
  require Ecto.Query

  alias Discuss.User
  alias Discuss.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  def where(params) do
    User
    |> Ecto.Query.where(^params)
    |> Repo.all()
  end

  def changeset(user, params \\ %{}) do
    user
    |> Ecto.Changeset.cast(params, [:email, :name, :provider, :token])
    |> Ecto.Changeset.validate_required([:email, :name, :provider, :token])
  end
end
