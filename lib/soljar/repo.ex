defmodule Soljar.Repo do
  use Ecto.Repo,
    otp_app: :soljar,
    adapter: Ecto.Adapters.SQLite3
end
