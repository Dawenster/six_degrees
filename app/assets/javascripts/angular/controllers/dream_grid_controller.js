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
    var input = element.parents(".confirm-buttons").siblings(".message-box")
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
      input.siblings(".existing-messages").append(result.message.content)
      input.val("")
      element.removeAttr("disabled")
    })
  }
}]);