# CartValleyServer

## Inastallation Guide
  * mix phx.new cart_valley_server --no-html --no-assets --no-live
  * cd cart_valley_server
  * configure password for postgres in dev/config.exs and .env file
  * mix ecto.create
  * mix phx.server or run shell ./start-server.sh with chmod +x start-server.sh permission