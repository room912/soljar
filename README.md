# Soljar

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Run dockerized app locally

docker build 

docker run --env SECRET_KEY_BASE="EcY/6SF54wQB5oC/Yrdi/5OMGEC0CBJ6luGaEqCuQcoCeOooZQrQNdFxuhfmV6KK" --env DATABASE_PATH=./data.db --env PHX_HOST=localhost soljar

<!-- Debug -->
docker run --env SECRET_KEY_BASE=123 --env DATABASE_PATH=./data.db --env PHX_HOST=localhost soljar sleep infinity