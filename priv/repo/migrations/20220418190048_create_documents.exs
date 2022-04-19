defmodule Today.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :name, :string
      add :body, :map

      timestamps()
    end
  end
end
