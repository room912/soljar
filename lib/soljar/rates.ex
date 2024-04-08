defmodule Soljar.Rates do
  def solana_to_usd() do
    usd_rate = Req.get!("https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd").body["solana"]["usd"]

    Soljar.SolRates.create_sol_rate(%{usd: Money.parse!(usd_rate, :USD)})
  end
end
