defmodule Jellystone.Databases.Namespace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Databases.Site

  schema "namespaces" do
    field :name, :string
    field :total_deployments, :integer, virtual: true

    belongs_to :site, Site
  end

  @doc false
  def changeset(namespace, attrs) do
    namespace
    |> cast(attrs, [:name, :site_id])
    |> validate_required([:name, :site_id])
    |> unique_constraint([:name, :site_id])
  end
end
