defmodule Jellystone.Databases.Deployment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deployments" do
    field :name, :string
    field :namespace, :id
  end

  @doc false
  def changeset(deployment, attrs) do
    deployment
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
