defmodule TicTacToeWeb.GameLive do
  use TicTacToeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:board, %{})
     |> assign(:player, "X")
     |> assign(:pause, false)}
  end

  def render(assigns) do
    ~H"""
    <label id="player-changer">Current player: <%= @player %></label>
    <div class="board">
      <div class="square" phx-value-id='0' phx-click="move"><%= @board["0"] %></div>
      <div class="square" phx-value-id='1' phx-click="move"><%= @board["1"] %></div>
      <div class="square" phx-value-id='2' phx-click="move"><%= @board["2"] %></div>
      <div class="square" phx-value-id='3' phx-click="move"><%= @board["3"] %></div>
      <div class="square" phx-value-id='4' phx-click="move"><%= @board["4"] %></div>
      <div class="square" phx-value-id='5' phx-click="move"><%= @board["5"] %></div>
      <div class="square" phx-value-id='6' phx-click="move"><%= @board["6"] %></div>
      <div class="square" phx-value-id='7' phx-click="move"><%= @board["7"] %></div>
      <div class="square" phx-value-id='8' phx-click="move"><%= @board["8"] %></div>
    </div>
    <br/>
    <.button phx-click="reset">Reset</.button>
    """
  end

  def handle_event("move", event, socket) do
    id = event["id"]
    player = socket.assigns.player
    board = socket.assigns.board
    pause = socket.assigns.pause

    {new_board, new_player, pause} = move(id, board, player, pause)

    case is_won?(new_board) do
      true ->
        {
          :noreply,
          socket
          |> assign(:pause, pause)
          |> assign(:board, new_board)
          |> assign(:player, new_player)
          |> put_flash(:info, "Player #{player} wins!")
        }

      false ->
        case is_board_full?(new_board) do
          true ->
            {
              :noreply,
              socket
              |> assign(:pause, pause)
              |> assign(:board, new_board)
              |> assign(:player, new_player)
              |> put_flash(:info, "Draw!")
            }

          false ->
            {
              :noreply,
              socket
              |> assign(:pause, pause)
              |> assign(:board, new_board)
              |> assign(:player, new_player)
            }
        end
    end
  end

  def handle_event("reset", _, socket) do
    {:noreply, socket |> assign(:board, %{}) |> assign(:player, "X") |> assign(:pause, false)}
  end

  defp move(id, board, player, pause) when pause == false do
    case Map.get(board, id) do
      nil ->
        board = Map.put(board, id, player)

        case is_won?(board) do
          true -> {board, player, true}
          false -> {board, change_player(player), false}
        end

      _ ->
        {board, player, false}
    end
  end

  defp move(_id, board, player, pause) do
    {board, player, pause}
  end

  defp change_player(player) do
    if player == "X", do: "O", else: "X"
  end

  defp is_board_full?(board) do
    0..8 |> Enum.all?(&Map.has_key?(board, Integer.to_string(&1)))
  end

  # TODO: make this more efficient, preferably without hard coding pattern
  defp is_won?(board) do
    win_pattern = [
      {"0", "1", "2"},
      {"3", "4", "5"},
      {"6", "7", "8"},
      {"0", "3", "6"},
      {"1", "4", "7"},
      {"2", "5", "8"},
      {"0", "4", "8"},
      {"2", "4", "6"}
    ]

    Enum.any?(win_pattern, fn x ->
      {x1, x2, x3} = x

      Map.get(board, x1) != nil and Map.get(board, x1) == Map.get(board, x2) and
        Map.get(board, x2) == Map.get(board, x3)
    end)
  end
end
