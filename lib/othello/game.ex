defmodule Othello.Game do


  def new do
    %{
      value: next_game(),
      history: List.duplicate(0, 64),
      current: List.duplicate(0, 64),
      firstClick: -1,
      secondClick: -1,
      stepNumber: 0,
      hideOrnot: false,
    }
  end

  def client_view(game) do
    ##guess(game)
    # newCurrent = game.current
    #
    if game.hideOrnot == true do
      %{
        game1: %{
          value: game.value,
          history: game.history,
          current: game.current,
          firstClick: game.firstClick,
          secondClick: game.secondClick,
          stepNumber: game.stepNumber,
          hideOrnot: game.hideOrnot,
        },
        game2: %{
          value: game.value,
          history: game.history,
          current: game.history,
          firstClick: game.firstClick,
          secondClick: game.secondClick,
          stepNumber: game.stepNumber,
          hideOrnot: game.hideOrnot,
        }

      }
    else
      %{
        game1: %{
          value: game.value,
          history: game.history,
          current: game.current,
          firstClick: game.firstClick,
          secondClick: game.secondClick,
          stepNumber: game.stepNumber,
          hideOrnot: game.hideOrnot,
        },
        game2: %{
          value: game.value,
          history: game.history,
          current: game.history,
          firstClick: game.firstClick,
          secondClick: game.secondClick,
          stepNumber: game.stepNumber,
          hideOrnot: game.hideOrnot,
        }

      }

    end


    #IO.inspect(game)
  end

  def guess(game, i) do

    newHistory = game.history
    newCurrent = game.current
    newFirstClick = game.firstClick
    newSecondClick = game.secondClick
    newStepNumber = game.stepNumber
    newHideOrnot = game.hideOrnot
    # IO.puts("inside")
    # Map.put(game, :current, gs)
    # Map.put(game, :secondClick, -1)
    # Map.put(game, :firstClick, i)
    # Map.put(game, :stepNumber, game.stepNumber + 1)
    # Map.put(game, :history, game.history)



    cond do
      game.hideOrnot == true ->
        newCurrent = newHistory

        newStepNumber = game.stepNumber + 1
        newHideOrnot = false

      game.firstClick == -1 ->
        newCurrent = newHistory
        newCurrent = List.replace_at(newCurrent,i, Enum.at(game.value,i))
        newStepNumber = game.stepNumber + 1
        newFirstClick = i
        newHideOrnot = false


        # Map.put(game, :current, squares)
        # Map.put(game, :secondClick, -1)
        # Map.put(game, :firstClick, i)
        # Map.put(game, :stepNumber, game.stepNumber + 1)


      (game.firstClick != -1) && (game.secondClick == -1) ->
        if Enum.at(game.current,i) == "" do
          if Enum.at(game.value,game.firstClick) == Enum.at(game.value,i) do

            # %{
            #   history: squares,
            #   current: squares,
            #   secondClick: -1,
            #   firstClick: -1,
            #   stepNumber: game.stepNumber + 1
            # }
            newCurrent = List.replace_at(newCurrent,i, Enum.at(game.value,i))
            newHistory = newCurrent
            newFirstClick = -1
            newSecondClick = -1
            newStepNumber = game.stepNumber + 1
            newHideOrnot = false

            # Map.put(game, :current, squares)
            #
            # Map.put(game, :history, squares)
            # Map.put(game, :secondClick, -1)
            # Map.put(game, :firstClick, -1)
            # Map.put(game, :stepNumber, game.stepNumber + 1)

          else
            #
            # %{
            #
            #   current: squares,
            #   secondClick: i,
            #   stepNumber: game.stepNumber + 1
            # }
            newCurrent = List.replace_at(newCurrent,i, Enum.at(game.value,i))

            newFirstClick = -1
            newSecondClick = -1
            newStepNumber = game.stepNumber + 1
            newHideOrnot = true

            # Map.put(game, :current, squares)
            # Map.put(game, :secondClick, i)
            # Map.put(game, :stepNumber, game.stepNumber + 1)
          end
        else


        end


      ##game.ID = setTimeout(this.showHisory.bind(this),1000)
      (game.firstClick != -1) && (game.secondClick != -1) ->
          if Enum.at(game.current,i) == "" do
            newCurrent = newHistory
            newFirstClick = -1
            newSecondClick = -1
            newHideOrnot = false
          end
          #
          # %{
          #   current: game.history,
          #   secondClick: -1,
          #   firstClick: -1,
          # }

          # Map.put(game, :current, game.history)
          # Map.put(game, :secondClick, -1)
          # Map.put(game, :firstClick, -1)


    end
    ##Map.put(game, :current, newCurrent)
    %{
      value: game.value,
      history: newHistory,
      current: newCurrent,
      firstClick: newFirstClick,
      secondClick: newSecondClick,
      stepNumber: newStepNumber,
      hideOrnot: newHideOrnot,
      # Map.put(game, :history, newHistory)
      #
      # Map.put(game, :secondClick, newStepNumber)
      # Map.put(game, :firstClick, newFirstClick)
      # Map.put(game, :stepNumber, newStepNumber)
      # Map.put(game, :current, newCurrent)

    }



  end


  def next_game() do
    letters = ~w(A B C D E F G H A B C D E F G H)

    Enum.shuffle(letters)
  end
end
