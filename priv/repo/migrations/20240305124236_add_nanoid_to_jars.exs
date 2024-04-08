defmodule Soljar.Repo.Migrations.AddNanoidToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :uri, :string, null: false
    end

    create unique_index(:jars, [:uri])
  end
end
