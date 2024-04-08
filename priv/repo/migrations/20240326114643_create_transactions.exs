defmodule Soljar.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :sig, :string, null: false
      add :amount, :integer, null: false
      add :name, :string
      add :message, :string
      add :jar_id, references(:jars, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:jar_id])
  end
end
