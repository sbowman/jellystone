defmodule Jellystone.Databases.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  schema "registrations" do
    field :description, :string
    field :name, :string
    field :team, :id
    field :deployment, :id

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end
end
