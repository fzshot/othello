defmodule OthelloWeb.UserSocket do
  use Phoenix.Socket
  alias Othello.Presence

  ## Channels
  # channel "room:*", OthelloWeb.RoomChannel
  channel "games:*", OthelloWeb.GamesChannel
  channel "index:lobby", OthelloWeb.IndexChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  # Idea borrowed from: https://stackoverflow.com/questions/41735442/phoenix-framework-generate-random-string-using-the-controller
  def connect(params, socket) do
    rand = :crypto.strong_rand_bytes(32) |> Base.encode64 |> binary_part(0, 32)
    {:ok, assign(socket, :user_id, rand)}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     OthelloWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  # def id(_socket), do: nil
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end
