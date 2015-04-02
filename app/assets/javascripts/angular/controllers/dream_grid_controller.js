var app = angular.module('sixdegrees');

app.controller('DreamGridCtrl', ['$scope', function($scope) {
  $("body").on("click", ".send-connection-button", function() {
    var element = $(this)
    element.attr('disabled','disabled')
        
    var form = $(this).parents("form")
    var url = form.attr("action")
    var method = form.attr("method")
    var data = form.serializeArray()

    $.ajax({
      url: url,
      method: method,
      data: data
    })
    .done(function(result) {
      element.parents(".offering-dream-section").html(result.connection_display)
    })
  })

  $("body").on("click", ".dream-help-button", function() {
    var signedIn = $(".dream-grid-holder").attr("data-user-signed-in")
    if (signedIn == "true") {
      $(this).siblings(".connection-form").toggle()
      $(this).siblings(".confirm-buttons").toggle()
      $(this).toggle()
    }
  })

  $("body").on("click", ".cancel-link", function() {
    $(this).parent().siblings(".connection-form").toggle()
    $(this).parent().siblings(".dream-help-button").toggle()
    $(this).parent().toggle()
  })
}]);