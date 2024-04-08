defmodule Soljar.SolRates.SolRate do
  use Ecto.Schema
  import Ecto.Changeset


  schema "sol_rates" do
    field :usd, Money.Ecto.Map.Type

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:usd])
    |> validate_required([:usd])
  end
end
