defmodule Jellystone.Databases.Namespace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Databases.Site

  schema "namespaces" do
    field :name, :string

    belongs_to :site, Site
  end

  @doc false
  def changeset(namespace, attrs) do
    namespace
    |> cast(attrs, [:name, :site_id])
    |> validate_required([:name])
    |> validate_required([:site_id])
    |> unique_constraint(:name)
  end
end
