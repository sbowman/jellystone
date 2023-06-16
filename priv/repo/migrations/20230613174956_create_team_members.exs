defmodule Jellystone.Repo.Migrations.CreateTeamMembers do
  use Ecto.Migration

  def change do
    create table(:team_members) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:team_members, [:team_id, :user_id], unique: true)
    create index(:team_members, [:user_id])
  end
end
