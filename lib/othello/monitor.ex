defmodule Othello.Presence do
  use Phoenix.Presence, otp_app: :othello,
    pubsub_server: Othello.PubSub
end
