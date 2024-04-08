defmodule Soljar.Repo.Migrations.AddColumnsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :wallet_address, :string
      add :provider, :string
    end
  end
end
