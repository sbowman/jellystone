defmodule Jellystone.Databases.DatabaseTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "database_tags" do
    field :tag, :id
    field :registration, :id
  end

  @doc false
  def changeset(database_tag, attrs) do
    database_tag
    |> cast(attrs, [])
    |> validate_required([])
  end
end
