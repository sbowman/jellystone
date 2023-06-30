defmodule Jellystone.Databases.Deployment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Databases.Namespace

  schema "deployments" do
    field :name, :string
    field :total_databases, :integer, virtual: true

    belongs_to :namespace, Namespace
  end

  @doc false
  def changeset(deployment, attrs) do
    deployment
    |> cast(attrs, [:name, :namespace_id])
    |> validate_required([:name, :namespace_id])
    |> unique_constraint([:name, :namespace_id])
  end
end
