defmodule Jellystone.Databases.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Databases.Deployment

  schema "registrations" do
    field(:description, :string)
    field(:name, :string)
    field(:team, :id)

    belongs_to(:deployment, Deployment)

    timestamps()
  end

  @doc false
  def changeset(registration, attrs) do
    registration
    |> cast(attrs, [:name, :description, :deployment_id])
    |> validate_required([:name, :deployment_id])
    |> unique_constraint([:name, :deployment_id])
  end
end
