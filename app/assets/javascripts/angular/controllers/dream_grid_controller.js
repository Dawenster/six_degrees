var app = angular.module('sixdegrees');

app.controller('DreamGridCtrl', ['$scope', function($scope) {
  $scope.showConfirm = false

  $("body").on("click", ".send-connection-button", function() {
    var element = $(this)
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
}]);