var app = angular.module('sixdegrees');

app.controller('HelpedReceivedGridCtrl', ['$scope', "Connections", function($scope, Connections) {
  $scope.accepted = false
  $scope.declined = false

  $scope.canShow = function(status, id) {
    if (typeof status === 'undefined' && noActionsTaken()) {
      $scope.showButtons = true
    } else {
      return status
    }
  }

  $scope.accept = function(url) {
    Connections.updateStatus(url)
    $scope.accepted = true
    $scope.showButtons = false
    updateBadgeNum()
  }

  $scope.decline = function(url) {
    Connections.updateStatus(url)
    $scope.declined = true
    $scope.showButtons = false
    updateBadgeNum()
  }

  function updateBadgeNum() {
    var badgeNums = $(".received-badge-num")
    for (var i = 0; i < badgeNums.length; i++) {
      var currentNum = parseInt($(badgeNums[i]).text())
      if (currentNum == 1) {
        $(badgeNums[i]).remove()
      } else {
        $(badgeNums[i]).text(currentNum - 1)
      }
    };
  }

  function noActionsTaken() {
    return !($scope.accepted || $scope.declined)
  }
}]);