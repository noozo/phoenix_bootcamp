# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+/CrdxzRq1J4+wgXH7FSBFG+o/2yTEB6FZJMd75af8U+RqkkNdsVYDshl+q0j9pH",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Github oauth
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ],
  json_library: Jason

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "dd8c61c1b607b0141a4c",
  client_secret: "85223d8ba43d0d34e63e9fc06b4539a9e96dc621"
