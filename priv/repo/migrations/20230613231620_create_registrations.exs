defmodule Jellystone.Repo.Migrations.CreateRegistrations do
  use Ecto.Migration

  def change do
    create table(:registrations) do
      add :name, :string, null: false
      add :description, :string
      add :team, references(:teams, on_delete: :nothing), null: false
      add :deployment_id, references(:deployments, on_delete: :nilify_all)

      timestamps()
    end

    create unique_index(:registrations, [:name, :deployment_id])
    create index(:registrations, [:team])
    create index(:registrations, [:deployment_id])
  end
end
