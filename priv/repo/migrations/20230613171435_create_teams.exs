defmodule Jellystone.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, size: 64, null: false
      add :hashed_token, :string, size: 128, null: false

      timestamps()
    end

    create index(:teams, [:name], unique: true)
  end
end
