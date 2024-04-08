defmodule Soljar.Repo.Migrations.CreateJars do
  use Ecto.Migration

  def change do
    create table(:jars) do
      add :name, :string
      add :description, :string
      add :goal_amount, :integer, default: 0
      add :collected_amount, :integer, default: 0

      timestamps(type: :utc_datetime)
    end
  end
end
