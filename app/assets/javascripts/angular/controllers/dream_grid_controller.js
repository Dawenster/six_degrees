var app = angular.module('sixdegrees');

app.controller('DreamGridCtrl', ['$scope', function($scope) {
  $("body").on("click", ".send-message-button", function() {
    createMessage($(this))
  })

  $(".message-box").keyup(function(e){
    if (e.keyCode == 13) {
      var element = $(this).siblings(".confirm-buttons").find(".send-message-button")
      createMessage(element)
    }
  });

  function createMessage(element) {
    var confirmButton = element.parents(".confirm-buttons")
    var credentialsInput = confirmButton.siblings(".credentials-box:visible")
    var credentialsText = credentialsInput.val()
    var messageInput = confirmButton.siblings(".message-box:visible")
    var messageText = messageInput.val()

    if (credentialsText == "" || messageText == "") {

      showErrorBox(confirmButton)

    } else {
      element.attr('disabled', 'disabled')
      hideErrorBox(confirmButton)

      var url = messageInput.attr("data-message-url")
      var dream_id = messageInput.attr("data-dream-id")
      var recipient_id = messageInput.attr("data-recipient-user-id")
      var url = messageInput.attr("data-message-url")
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
        messageInput.parents(".offering-dream-section").find(".existing-messages").append(result.message_with_html)
        if (result.connection_with_html) {
          messageInput.parents(".dream-grid-holder").find(".existing-connections").append(result.connection_with_html)
        }
        messageInput.val("")
        element.removeAttr("disabled")
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