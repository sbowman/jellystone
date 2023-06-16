defmodule Jellystone.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string, null: false
    end

    create unique_index(:sites, [:name])
  end
end
