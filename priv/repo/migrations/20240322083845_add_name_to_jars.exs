defmodule Soljar.Repo.Migrations.AddNameToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :collector_name, :string
    end
  end
end
