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
    element.attr('disabled', 'disabled')
    var input = element.parents(".confirm-buttons").siblings(".message-box:visible")
    var url = $(input).attr("data-message-url")
    var method = "post"
    var data = {
      content: $(input).val(),
      dream_id: $(input).attr("data-dream-id")
    }

    $.ajax({
      url: url,
      method: method,
      data: data
    })
    .done(function(result) {
      input.parents(".offering-dream-section").find(".existing-messages").append(result.message_with_html)
      input.val("")
      element.removeAttr("disabled")
    })
  }

  $("body").on("change", ".select-private-helper", function() {
    var userId = $(this).val()
    var streams = $(this).parents(".owner-of-dream-messages-holder").find(".owner-of-dream-specific-user-message-stream")
    for (var i = 0; i < streams.length; i++) {
      if ($(streams[i]).attr("data-user-id") == userId) {
        $(streams[i]).removeClass("hide")
      } else {
        $(streams[i]).addClass("hide")
      }
    };
  })

  function showMessageStreamForUser() {

  }
}]);