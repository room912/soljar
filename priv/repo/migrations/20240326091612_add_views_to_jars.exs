defmodule Soljar.Repo.Migrations.AddViewsToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      add :views, :integer, default: 0
    end
  end
end
