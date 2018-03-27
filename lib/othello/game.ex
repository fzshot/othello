defmodule Othello.Game do

  defp init do
    row = List.duplicate("", 8)
    r1 = row
    |> List.replace_at(3, "W")
    |> List.replace_at(4, "B")
    r2 = row
    |> List.replace_at(3, "B")
    |> List.replace_at(4, "W")
    List.duplicate(row, 8)
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
      count: 1,
    }
  end

  defp isLegal(place) do
    place >= 0 and place <= 63
  end

  def isLegalRowCol(row, col) do
    row >= 0 and row <= 7 and col >= 0 and col <= 7
  end

  defp isLegalMove(board, place, turn) do
    if !isLegal(place) or Enum.at(board, place) != "" do
      false
    else
      testHor(board, place, turn) or
      testVer(board, place, turn) or
      testDia(board, place, turn)
    end
  end

  defp vHHelpL(row, place, turn, last) do
    if !isLegal(place) do
      false
    else
      disc = Enum.at(row, place)
      if disc == nil or disc == "" do
        false
      else
        if disc == turn do
          if last == turn do
            false
          else
            true
          end
        else
          vHHelpL(row, place-1, turn, disc)
        end
      end
    end
  end

  defp vHHelpR(row, place, turn, last) do
    if !isLegal(place) do
      false
    else
      disc = Enum.at(row, place)
      if disc == nil or disc == "" do
        false
      else
        if disc == turn do
          if last == turn do
            false
          else
            true
          end
        else
          vHHelpR(row, place+1, turn, disc)
        end
      end
    end
  end

  defp testHor(board, place, turn) do
    row = div(place, 8)
    col = rem(place, 8)
    tempRow = Enum.slice(board, row*8, 8)
    vHHelpL(tempRow, col-1, turn, turn) or
    vHHelpR(tempRow, col+1, turn, turn)
  end

  defp testVer(board, place, turn) do
    row = div(place, 8)
    col = rem(place, 8)
    tempRow = Enum.slice(board, col, 64)
    |> Enum.take_every(8)
    vHHelpL(tempRow, row-1, turn, turn) or
    vHHelpR(tempRow, row+1, turn, turn)
  end

  defp testLDia(board, row, col, turn) do
    diaHelpLU(board, row-1, col-1, turn, turn) or
    diaHelpLD(board, row+1, col+1, turn, turn)
  end

  defp testRDia(board, row, col, turn) do
    diaHelpRU(board, row-1, col+1, turn, turn) or
    diaHelpRD(board, row+1, col-1, turn, turn)
  end

  defp diaHelpRU(board, row, col, turn, last) do
    if isLegalRowCol(row, col) do
      boardRow = Enum.at(board, row)
      if boardRow do
        disc = Enum.at(boardRow, col)
        if disc == nil or disc == "" do
          false
        else
          if disc == turn do
            if last == turn do
              false
            else
              true
            end
          else
            diaHelpRU(board, row-1, col+1, turn, disc)
          end
        end
      else
        false
      end
    else
      false
    end
  end

  defp diaHelpRD(board, row, col, turn, last) do
    if isLegalRowCol(row, col) do
      boardRow = Enum.at(board, row)
      if boardRow do
        disc = Enum.at(boardRow, col)
        if disc == nil or disc == "" do
          false
        else
          if disc == turn do
            if last == turn do
              false
            else
              true
            end
          else
            diaHelpRD(board, row+1, col-1, turn, disc)
          end
        end
      else
        false
      end
    else
      false
    end
  end

  defp diaHelpLU(board, row, col, turn, last) do
    if isLegalRowCol(row, col) do
      boardRow = Enum.at(board, row)
      if boardRow do
        disc = Enum.at(boardRow, col)
        if disc == nil or disc == "" do
          false
        else
          if disc == turn do
            if last == turn do
              false
            else
              true
            end
          else
            diaHelpLU(board, row-1, col-1, turn, disc)
          end
        end
      else
        false
      end
    else
      false
    end
  end

  defp diaHelpLD(board, row, col, turn, last) do
    if isLegalRowCol(row, col) do
      boardRow = Enum.at(board, row)
      if boardRow do
        disc = Enum.at(boardRow, col)
        if disc == nil or disc == "" do
          false
        else
          if disc == turn do
            if last == turn do
              false
            else
              true
            end
          else
            diaHelpLD(board, row+1, col+1, turn, disc)
          end
        end
      else
        false
      end
    else
      false
    end
  end

  defp testDia(board, place, turn) do
    row = div(place, 8)
    col = rem(place, 8)
    tempBoard = Enum.chunk_every(board, 8)
    testLDia(tempBoard, row, col, turn) or
    testRDia(tempBoard, row, col, turn)
  end

  defp allValidMove(board, turn, result, place) do
    if place >= 64 do
      result
    else
      result or
      allValidMove(board, turn, isLegalMove(board, place, turn), place+1)
    end
  end

  defp replaceL(row, place, turn) do
    if isLegal(place) do
      disc = Enum.at(row, place)
      if disc == turn or disc == nil or disc == "" do
        row
      else
        List.replace_at(row, place, turn)
        |> replaceL(place-1, turn)
      end
    else
      row
    end
  end

  defp replaceR(row, place, turn) do
    if isLegal(place) do
      disc = Enum.at(row, place)
      if disc == turn or disc == nil or disc == "" do
        row
      else
        List.replace_at(row, place, turn)
        |> replaceR(place+1, turn)
      end
    else
      row
    end
  end

  defp flipHor(board, place, turn) do
    if testHor(board, place, turn) do
      row = div(place, 8)
      col = rem(place, 8)
      tempRow = Enum.slice(board, row*8, 8)
      left = vHHelpL(tempRow, col-1, turn, turn)
      right = vHHelpR(tempRow, col+1, turn, turn)
      newRow = tempRow
      if left do
        newRow = replaceL(newRow, col-1, turn)
      end
      if right do
        newRow = replaceR(newRow, col+1, turn)
      end
      Enum.chunk_every(board, 8)
      |> List.replace_at(row, newRow)
      |> List.flatten
    else
      board
    end
  end

  defp replaceU(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      board = Enum.chunk_every(board, 8)
      tempRow = Enum.at(board, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(board, row, newRow)
        |> List.flatten
        |> replaceU(row-1, col, turn)
      end
    else
      List.flatten(board)
    end
  end

  defp replaceD(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      board = Enum.chunk_every(board, 8)
      tempRow = Enum.at(board, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(board, row, newRow)
        |> List.flatten
        |> replaceD(row+1, col, turn)
      end
    else
      List.flatten(board)
    end
  end

  def replaceLDiaU(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      tempBoard = Enum.chunk_every(board, 8)
      tempRow = Enum.at(tempBoard, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(tempBoard, row, newRow)
        |> List.flatten
        |> replaceLDiaU(row-1, col-1, turn)
      end
    else
      List.flatten(board)
    end
  end

  def replaceLDiaD(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      tempBoard = Enum.chunk_every(board, 8)
      tempRow = Enum.at(tempBoard, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(tempBoard, row, newRow)
        |> List.flatten
        |> replaceLDiaD(row+1, col+1, turn)
      end
    else
      List.flatten(board)
    end
  end

  def replaceRDiaU(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      tempBoard = Enum.chunk_every(board, 8)
      tempRow = Enum.at(tempBoard, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(tempBoard, row, newRow)
        |> List.flatten
        |> replaceRDiaU(row-1, col+1, turn)
      end
    else
      List.flatten(board)
    end
  end

  def replaceRDiaD(board, row, col, turn) do
    if isLegalRowCol(row, col) do
      tempBoard = Enum.chunk_every(board, 8)
      tempRow = Enum.at(tempBoard, row)
      disc = Enum.at(tempRow, col)
      if disc == turn or disc == nil or disc == "" do
        List.flatten(board)
      else
        newRow = List.replace_at(tempRow, col, turn)
        List.replace_at(tempBoard, row, newRow)
        |> List.flatten
        |> replaceRDiaD(row+1, col-1, turn)
      end
    else
      List.flatten(board)
    end
  end

  defp flipVer(board, place, turn) do
    if testVer(board, place, turn) do
      row = div(place, 8)
      col = rem(place, 8)
      tempRow = board
      |> Enum.slice(col, 64)
      |> Enum.take_every(8)
      left =  vHHelpL(tempRow, row-1, turn, turn)
      right = vHHelpR(tempRow, row+1, turn, turn)
      newBoard = board
      if left do
        newBoard = replaceU(newBoard, row-1, col, turn)
      end
      if right do
        newBoard = replaceD(newBoard, row+1, col, turn)
      end
      newBoard
    else
      board
    end
  end

  defp flipDia(board, place, turn) do
    if testDia(board, place, turn) do
      row = div(place, 8)
      col = rem(place, 8)
      tempBoard = Enum.chunk_every(board, 8)
      left = testLDia(tempBoard, row, col, turn)
      right = testRDia(tempBoard, row, col, turn)
      newBoard = board
      if left do
        newBoard = replaceLDiaU(newBoard, row-1, col-1, turn)
        |> replaceLDiaD(row+1, col+1, turn)
      end
      if right do
        newBoard = replaceRDiaU(newBoard, row-1, col+1, turn)
        |> replaceRDiaD(row+1, col-1, turn)
      end
      newBoard
    else
      board
    end
  end

  defp flip(board, place, turn) do
    board
    |> flipHor(place, turn)
    |> flipVer(place, turn)
    |> flipDia(place, turn)
    |> List.replace_at(place, turn)
  end

  defp countWin(board) do
    b = Enum.count(board, fn x -> x == "B" end)
    w = Enum.count(board, fn x -> x == "W" end)
    cond do
      b > w ->
        %{
          current: board,
          win: true,
          winner: "B"
        }
      b < w ->
        %{
          current: board,
          win: true,
          winner: "W"
        }
      true ->
        %{
          current: board,
          win: true,
          winner: "T"
        }
    end
  end

  def testPlace(currentGame, place, player, turn) do
    board = currentGame[:current]
    win = currentGame[:win]
    if player != turn or Enum.at(board, place) != "" or win do
      %{
        current: board
      }
    else
      if isLegalMove(board, place, turn) do
        newBoard = flip(board, place, turn)
        newTurn =
          if turn == "W" do
            "B"
          else
            "W"
          end
        if allValidMove(newBoard, newTurn, false, 0) do
          %{
            current: newBoard,
            turn: newTurn
          }
        else
          if allValidMove(newBoard, turn, false, 0) do
            %{
              current: newBoard,
              turn: turn
            }
          else
            countWin(newBoard)
          end
        end
      else
        %{
          current: board
        }
      end
    end
  end

end

