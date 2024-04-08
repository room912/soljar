defmodule Soljar.Repo.Migrations.AddUserRefToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:jars, [:user_id])
  end
end
