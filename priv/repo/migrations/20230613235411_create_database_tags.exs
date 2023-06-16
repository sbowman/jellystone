defmodule Jellystone.Repo.Migrations.CreateDatabaseTags do
  use Ecto.Migration

  def change do
    create table(:database_tags) do
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
      add :registration_id, references(:registrations, on_delete: :delete_all), null: false
    end

    create index(:database_tags, [:tag_id, :registration_id], unique: true)
    create index(:database_tags, [:registration_id])
  end
end
