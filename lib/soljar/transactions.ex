defmodule Soljar.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Soljar.Repo
  alias Soljar.Jars.Jar

  alias Soljar.Transactions.Transaction

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, transaction} ->
        transaction = Repo.preload(transaction, :jar)

        Phoenix.PubSub.broadcast!(
          Soljar.PubSub,
          "user:#{transaction.jar.user_id}",
          {__MODULE__, %Soljar.Transactions.Events.TransactionSubmited{transaction: transaction}}
        )

        {:ok, transaction}
      error -> error
    end
  end

  def list_transactions(user_id) do
    Transaction
    |> join(:inner, [t], j in Jar, on: t.jar_id == j.id)
    |> preload(:jar)
    |> where([t, j], j.user_id == ^user_id)
    |> order_by(desc: :id)
    |> Repo.all()
  end
end
