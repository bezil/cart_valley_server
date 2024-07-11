#!/bin/bash

# Source the .env file
source .env

mix ecto.setup

# Start the Phoenix server
iex -S mix phx.server
