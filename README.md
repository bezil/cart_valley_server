# CartValleyServer

## Installation Guide
  * mix phx.new cart_valley_server --no-html --no-assets --no-live
  * cd cart_valley_server
  * configure password for postgres in dev/config.exs and .env file
  * mix ecto.setup
  * mix phx.server or run shell ./start-server.sh with chmod +x start-server.sh permission
  * mix ecto.seed for seeding initial data
  * mix test for testing

## Notes
- Server will running on http://localhost:4000/
- Client assumed to be running on "http://localhost:5173",
  if not update `config.exs` with origin
  ```
  config :cors_plug,
    origins: ["http://localhost:5173"],
    allow_headers: ["content-type"],
    max_age: 86400,
    methods: ["GET", "POST", "DELETE", "PUT", "OPTIONS"]
  ```
- Create .env file with postgres password
  ```
  export DATABASE_PASSWORD="postgres"
  ```
- For test, first source `.env` file then run mix test
  ```
    source .env
    run mix test
  ```
