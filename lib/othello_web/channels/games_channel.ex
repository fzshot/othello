defmodule OthelloWeb.GamesChannel do
  use OthelloWeb, :channel

  alias Othello.Game
  alias Othello.Presence

  defp getSize(size) do
    case size do
      1 -> "W"
      _ -> "N"
    end

  end

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      state = Othello.GameBackup.load(name)
      if state do
        state = Map.put(state, :count, true)
        Othello.GameBackup.save(name, state)
        if state[:win] do
          state = Map.put(state, :player, "N")
        else
          list = Presence.list(socket)
          player = list
          |> map_size
          |> getSize
          state = Map.put(state, :player, player)
        end
        send(self(), :after_join)
        socket = socket
        |> assign(:game, state)
        |> assign(:name, name)
        {:ok, %{"join" => name, "game" => state}, socket}
      else
        game = Game.new()
        |> Map.put(:player, "B")
        socket = socket
        |> assign(:game, game)
        |> assign(:name, name)
        Othello.GameBackup.save(name, game)
        send(self(), :after_join)
        {:ok, %{"join" => name, "game" => game}, socket}
      end
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("place", %{"place" => place, "turn" => turn}, socket) do
    id = socket.assigns[:user_id]
    list = Presence.list(socket)
    name = socket.assigns[:name]
    player = Map.get(list, id)
    |> Map.get(:metas)
    |> hd
    |> Map.get(:player)
    IO.inspect(player)
    currentGame = Othello.GameBackup.load(name)
    newState = Game.testPlace(currentGame, place, player, turn)
    socket = assign(socket, :game, newState)
    Othello.GameBackup.save(name, newState)
    broadcast(socket, "update", %{"game" => newState})
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    list = Presence.list(socket)
    push socket, "presence_state", list
    name = socket.assigns[:name]
    currentGame = Othello.GameBackup.load(name)
    if currentGame[:win] do
      {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "N"})
    else
      size = map_size(list)
      case size do
        0 ->
          {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "B"})
        1 ->
          {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "W"})
        _ ->
          {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "N"})
      end
    end
    {:noreply, socket}
  end

  # Idea borrowed from: https://stackoverflow.com/questions/41552760/how-could-i-know-amount-of-connections-to-channel-in-phoenix
  def terminate(_param, socket) do
    name = socket.assigns[:name]
    id = socket.assigns[:user_id]
    player = Presence.list(socket)
    |> Map.get(id)
    |> Map.get(:metas)
    |> hd
    |> Map.get(:player)
    if player != "N" do
      if player == "B" do
        player = "W"
      else
        player = "B"
      end
      newState = Othello.GameBackup.load(name)
      |> Map.put(:win, true)
      |> Map.put(:winner, player)
      |> Map.delete(:player)
      socket = assign(socket, :game, newState)
      Othello.GameBackup.save(name, newState)
      broadcast(socket, "left", %{"game" => newState})
    end
    Presence.untrack(socket, id)
    if Presence.list(socket) |> Enum.empty? do
      Othello.GameBackup.remove(name)
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
