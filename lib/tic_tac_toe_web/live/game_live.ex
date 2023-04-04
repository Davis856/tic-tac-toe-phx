defmodule TicTacToeWeb.GameLive do
  use TicTacToeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :player, 0)}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <div class="board">
        <div class="row">
          <div class="square"></div>
          <div class="square"></div>
          <div class="square"></div>
        </div>
        <div class="row">
          <div class="square"></div>
          <div class="square"></div>
          <div class="square"></div>
        </div>
        <div class="row">
          <div class="square"></div>
          <div class="square"></div>
          <div class="square"></div>
        </div>
      </div>
    </div>
    """
  end
end
