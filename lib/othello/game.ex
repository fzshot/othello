defmodule Othello.Game do

  def init do
    row = List.duplicate("", 8)
    r1 = row
    |> List.replace_at(3, "W")
    |> List.replace_at(4, "B")
    r2 = row
    |> List.replace_at(3, "B")
    |> List.replace_at(4, "W")
    display = List.duplicate(row, 8)
    |> List.replace_at(3, r1)
    |> List.replace_at(4, r2)
    |> List.flatten
  end

  def new do
    current = init()
    %{
      current: current,
      stepNumber: 0,
      win: false,
      turn: "B",
      player: "B",
    }
  end

  def testPlace(currentGame, place, player, turn) do
    if player != turn do
      currentGame
    else
      board = currentGame[:current]
      if Enum.at(board, place) != "" do
        currentGame
      else
        newBoard = List.replace_at(board, place, turn)
        newTurn = turn
        if turn == "B" do
          newTurn = "W"
        else
          newTurn = "B"
        end
        %{
          current: newBoard,
          turn: newTurn,
        }
      end
    end
  end

end

