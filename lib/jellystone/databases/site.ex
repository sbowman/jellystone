defmodule Jellystone.Databases.Site do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jellystone.Databases.Namespace

  schema "sites" do
    field :name, :string
    field :description, :string
    field :total_namespaces, :integer, virtual: true

    has_many :namespaces, Namespace
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
