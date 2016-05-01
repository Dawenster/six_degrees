var app = angular.module('sixdegrees');

app.controller('AlertsCtrl', ['$scope', '$element', function($scope, $element) {
  $element.on("click", "button", function() {
    $element.find(".alert").addClass("hide")
  })
}]);