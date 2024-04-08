defmodule Soljar.Repo.Migrations.CreateRates do
  use Ecto.Migration

  def change do
    create table(:sol_rates) do
      add :usd, :map, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
