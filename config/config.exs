# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :cart_valley_server,
  ecto_repos: [CartValleyServer.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :cart_valley_server, CartValleyServerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: CartValleyServerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CartValleyServer.PubSub,
  live_view: [signing_salt: "cYECMmCk"]

# Configures Cors
config :cors_plug,
  origins: ["http://localhost:5173"],
  allow_headers: ["content-type"],
  max_age: 86400,
  methods: ["GET", "POST", "DELETE", "PUT", "OPTIONS"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :cart_valley_server, CartValleyServer.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
