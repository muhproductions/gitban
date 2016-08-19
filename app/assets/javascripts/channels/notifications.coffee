App.notifications = App.cable.subscriptions.create "NotificationsChannel",
  received: (data) ->
    Materialize.toast('<b>' +
                      data['name'] +
                      '</b>&nbsp;was moved from&nbsp;<b>' +
                      data['source'] +
                      '</b>&nbsp;to&nbsp;<b>' +
                      data['destination'] +
                      '</b>&nbsp;by&nbsp;<b>' +
                      data['user'] +
                      '</b>', 30000)
