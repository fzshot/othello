defmodule OthelloWeb.GamesChannel do
  use OthelloWeb, :channel

  alias Othello.Game
  alias Othello.Presence
  alias OthelloWeb.Endpoint

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      state = Othello.GameBackup.load(name)
      if state do
        socket = socket
        |> assign(:game, state)
        |> assign(:name, name)
        send(self(), :after_join)
        {:ok, %{"join" => name, "game" => state}, socket}
      else
        game = Game.new()
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

    # game = Game.guess(socket.assigns[:game], i)
    # IO.inspect(game)
    # Memory.GameBackup.save(socket.assigns[:name], game)
    # socket = assign(socket, :game, game)
    # if s == true do
    #   if Game.client_view(game).game1.hideOrnot == false do
    #     {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    #   else
    #     #discussed with ceng zeng
    #     {:reply, {:hide, %{ "game" => Game.client_view(game)}}, socket}
    #   end
    #
    #
    # else
    #   {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}

    # if r == true do
    #     game = Game.new()
    #     Othello.GameBackup.save(socket.assigns[:name], game)
    #     socket = assign(socket, :game, game)
    #     {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    # else
    #     game = Game.guess(socket.assigns[:game], i)
    #     IO.inspect(game)
    #     Othello.GameBackup.save(socket.assigns[:name], game)
    #     socket = assign(socket, :game, game)
    #     if s == true do
    #       if Game.client_view(game).game1.hideOrnot == false do
    #         {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    #       else
    #         #discussed with ceng zeng
    #         {:reply, {:hide, %{ "game" => Game.client_view(game)}}, socket}
    #       end
    #     else
    #       {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
    #     end
    # end

  end

  def handle_info(:after_join, socket) do
    list = Presence.list(socket)
    push socket, "presence_state", list
    size = map_size(list)
    case size do
      0 ->
        {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "B"})
      1 ->
        {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "W"})
      _ ->
        {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{player: "N"})
    end
    {:noreply, socket}
  end

  # Idea borrowed from: https://stackoverflow.com/questions/41552760/how-could-i-know-amount-of-connections-to-channel-in-phoenix
  def terminate(param, socket) do
    # id = socket.assigns[:user_id]
    # Presence.untrack(socket, id)
    # if Presence.list(socket) |> Enum.empty? do
    #   broadcast(socket, "home", %{})
    #   name = socket.assigns[:name]
    #   Othello.GameBackup.remove(name)
    # end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
