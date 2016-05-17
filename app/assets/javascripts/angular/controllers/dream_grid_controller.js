var app = angular.module('sixdegrees');

app.controller('DreamGridCtrl', ['$scope', '$element', function($scope, $element) {

  var dialogTime = 4000

  $(document).ready(function() {
    $(".message-box").characterCounter();
  });

  $element.on("click", ".send-message-button", function() {
    createMessage()
  })

  // $(".message-box").keyup(function(e){
  //   if (e.keyCode == 13) {
  //     createMessage()
  //   }
  // });

  function createMessage() {
    var confirmButton = $element.find(".send-message-button")
    var credentialsInput = $element.find(".credentials-box:visible")
    var credentialsText = credentialsInput.val()
    var messageInput = $element.find(".message-box:visible")
    var messageText = messageInput.val()
    var limit = parseInt(messageInput.attr("length"))
    var messageLength = messageText.length

    if ((credentialsInput.length == 0 && credentialsText == "") || messageText == "") {

      Materialize.toast("Please fill everything in!", dialogTime)
      if (credentialsInput.length > 0 && credentialsText == "") {
        credentialsInput.focus()
      } else {
        messageInput.focus()
      }

    } else if (messageLength > limit) {

      Materialize.toast("Message is too long!", dialogTime)
      messageInput.focus()

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
        $element.find(".help-dream-link").text("MESSAGES (" + result.messages_count + ")")
        $element.find(".helpers-count-link").removeClass("hide")
        $element.find(".helpers-count-link").text("HELPERS (" + result.helpers_count + ")")
      })
    }
  }

  $element.on("change", ".select-private-helper", function() {
    showMessageStreamForUser($(this))
  })

  function showMessageStreamForUser(selectInput) {
    var userId = selectInput.val()
    var streams = selectInput.parents(".modal-content").find(".owner-of-dream-specific-user-message-stream")

    if (userId != "") {
      for (var i = 0; i < streams.length; i++) {
        if ($(streams[i]).data("user-id") == parseInt(userId)) {
          $(streams[i]).removeClass("hide")
        } else {
          $(streams[i]).addClass("hide")
        }
      };
    }
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

  $element.on("click", ".heart-count", function() {
    var dreamId = $element.data("dream-id")
    var hearted = $element.find(".heart-count").data("already-hearted")
    if (hearted) {
      unheart()
    } else {
      heart(dreamId)
    }
  })

  function heart(dreamId, heartUrl) {
    var heartUrl = $element.find(".heart-count").data("heart-url")

    $.ajax({
      url: heartUrl,
      method: "POST",
      data: {
        dream_id: dreamId
      }
    })
    .done(function(result) {
      $element.find(".fa-heart").text(" " + result.hearts)
      $element.find(".heart-count").data("already-hearted", true)
      $element.find(".heart-count").data("delete-heart-url", result.delete_heart_url)
    })
  }

  function unheart() {
    var heartUrl = $element.find(".heart-count").data("delete-heart-url")
    $.ajax({
      url: heartUrl,
      method: "DELETE"
    })
    .done(function(result) {
      $element.find(".fa-heart").text(" " + result.hearts)
      $element.find(".heart-count").data("already-hearted", false)
      $element.find(".heart-count").removeAttr("data-delete-heart-url")
    })
  }
}]);