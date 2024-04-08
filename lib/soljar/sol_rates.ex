defmodule Soljar.SolRates do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Soljar.Repo

  alias Soljar.SolRates.SolRate

  def create_sol_rate(attrs \\ %{}) do
    %SolRate{}
    |> SolRate.changeset(attrs)
    |> Repo.insert()
  end

  def latest() do
    SolRate
    |> order_by(desc: :id)
    |> limit(1)
    |> Repo.one()
  end
end
