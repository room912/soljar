defmodule Soljar.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Soljar.Jars.Jar

  schema "transactions" do
    field :sig, :string
    field :amount, Money.Ecto.Amount.Type
    field :name, :string
    field :message, :string

    belongs_to :jar, Jar

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:sig, :amount, :name, :message, :jar_id])
    |> assoc_constraint(:jar)
    |> validate_required([:sig, :amount])
  end

  def to_string(transaction) do
    "#{String.slice(transaction.sig, 0..8)}...#{String.slice(transaction.sig, -9..-1)}"
  end
end
