defmodule CartValleyServer.Repo do
  use Ecto.Repo,
    otp_app: :cart_valley_server,
    adapter: Ecto.Adapters.Postgres
end
