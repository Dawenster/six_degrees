var app = angular.module('sixdegrees');

app.controller('HelpedReceivedGridCtrl', ['$scope', function($scope) {
  var status = $(".received-grid-action-buttons").attr("data-status")
  if (status == "accepted") {
    $scope.accepted = true
  } else if (status == "declined") {
    $scope.declined = true
  } else {
    $scope.accepted = false
    $scope.declined = false
  }
}]);