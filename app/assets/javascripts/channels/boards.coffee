url = location.href
board_id = url.substring(url.lastIndexOf('/') + 1)

App.boards = App.cable.subscriptions.create {
  channel: "BoardsChannel",
  boardId: board_id
  },
  connected: ->
    @perform 'refresh', board: window.boardID
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#board').html(data.message.html)
    # Called when there's incoming data on the websocket for this channel

  moved: (board, task_id) ->
    @perform 'modify', board: window.boardID, task_id: task_id

  refresh: (board) ->
    @perform 'refresh', board: window.boardID
