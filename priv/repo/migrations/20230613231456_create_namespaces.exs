defmodule Jellystone.Repo.Migrations.CreateNamespaces do
  use Ecto.Migration

  def change do
    create table(:namespaces) do
      add :name, :string, null: false
      add :site_id, references(:sites, on_delete: :delete_all), null: false
    end

    create unique_index(:namespaces, [:name])
    create index(:namespaces, [:site_id])
  end
end
