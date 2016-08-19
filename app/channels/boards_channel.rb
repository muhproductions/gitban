# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BoardsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "boards"
  end

  def modify(data)
    ActionCable.server.broadcast('boards',
      message: {html: render_board(Board.find(data['board']), data['task_id']), task_id: data['task_id']})
  end

  def refresh(data)
    ActionCable.server.broadcast('boards',
      message: {html: render_board(Board.find(data['board']), nil)})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def render_board(board, task_id)
    ApplicationController.render(partial: 'boards/show',
                                 locals: { board: board, task_id: task_id})
  end
end
