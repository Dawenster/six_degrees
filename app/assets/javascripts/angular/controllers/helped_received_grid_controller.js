var app = angular.module('sixdegrees');

app.controller('HelpedReceivedGridCtrl', ['$scope', "Connections", function($scope, Connections) {
  $scope.canShow = function(status, id) {
    if (typeof status === 'undefined') {
      $scope.showButtons = true;
    } else {
      return status
    }
  }

  $scope.accept = function(url) {
    Connections.updateStatus(url)
    $scope.accepted = !$scope.accepted
    updateBadgeNum()
  }

  $scope.decline = function(url) {
    Connections.updateStatus(url)
    $scope.declined = !$scope.declined
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
}]);