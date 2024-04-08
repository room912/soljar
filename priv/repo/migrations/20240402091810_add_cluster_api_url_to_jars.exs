defmodule Soljar.Repo.Migrations.AddClusterApiUrlToJars do
  use Ecto.Migration

  def change do
    alter table(:jars) do
      # devent | testnet | mainnet-beta
      add :cluster_api_url, :string, default: "devnet"
    end
  end
end
