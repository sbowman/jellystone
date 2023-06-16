defmodule Jellystone.Repo.Migrations.CreateDeployments do
  use Ecto.Migration

  def change do
    create table(:deployments) do
      add :name, :string, null: false
      add :namespace_id, references(:namespaces, on_delete: :delete_all), null: false
    end

    create unique_index(:deployments, [:name])
    create index(:deployments, [:namespace_id])
  end
end
