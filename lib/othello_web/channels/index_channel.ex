defmodule OthelloWeb.IndexChannel do
  use OthelloWeb, :channel
  alias Othello.GameBackup

  def join("index:lobby", payload, socket) do
    if authorized?(payload) do
      gameList = GameBackup.getAll()
      |> Enum.map(fn x ->
        game = GameBackup.load(x)
        %{
          "name" => x,
          "win" => game[:win],
          "count" => game[:count]
        }
      end)
      {:ok, %{"gamelist" => gameList}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (index:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
