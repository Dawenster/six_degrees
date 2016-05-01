var app = angular.module('sixdegrees');

app.controller('DreamGridCtrl', ['$scope', '$element', function($scope, $element) {
  $element.on("click", ".send-message-button", function() {
    createMessage()
  })

  $(".message-box").keyup(function(e){
    if (e.keyCode == 13) {
      createMessage()
    }
  });

  function createMessage() {
    var confirmButton = $element.find(".send-message-button")
    var credentialsInput = $element.find(".credentials-box:visible")
    var credentialsText = credentialsInput.val()
    var messageInput = $element.find(".message-box:visible")
    var messageText = messageInput.val()

    if ((credentialsInput.length == 0 && credentialsText == "") || messageText == "") {

      showErrorBox(confirmButton)

    } else {

      confirmButton.addClass('disabled')
      hideErrorBox(confirmButton)

      var url = messageInput.data("message-url")
      var dream_id = messageInput.data("dream-id")
      var recipient_id = messageInput.data("recipient-user-id")
      var url = messageInput.data("message-url")
      var method = "post"

      hideCredentialsInputSection(credentialsInput)

      var data = {
        credentials: credentialsText,
        content: messageText,
        dream_id: dream_id,
        recipient_id: recipient_id
      }

      $.ajax({
        url: url,
        method: method,
        data: data
      })
      .done(function(result) {
        $element.find(".existing-messages").append(result.message_with_html)
        if (result.connection_with_html) {
          $element.find(".existing-connections").append(result.connection_with_html)
        }
        messageInput.val("")
        confirmButton.removeClass('disabled')
      })
    }
  }

  $("body").on("change", ".select-private-helper", function() {
    showMessageStreamForUser($(this))
  })

  function showMessageStreamForUser(element) {
    var userId = element.val()
    var streams = element.parents(".owner-of-dream-messages-holder").find(".owner-of-dream-specific-user-message-stream")
    for (var i = 0; i < streams.length; i++) {
      if ($(streams[i]).attr("data-user-id") == userId) {
        $(streams[i]).removeClass("hide")
      } else {
        $(streams[i]).addClass("hide")
      }
    };
  }

  function hideCredentialsInputSection(credentialsInput) {
    credentialsInput.addClass("hide")
    credentialsInput.siblings(".credentials-label").addClass("hide")
  }

  function showErrorBox(confirmButton) {
    var errorBox = confirmButton.siblings(".message-box-errors")
    errorBox.removeClass("hide")
  }

  function hideErrorBox(confirmButton) {
    var errorBox = confirmButton.siblings(".message-box-errors")
    errorBox.addClass("hide")
  }
}]);