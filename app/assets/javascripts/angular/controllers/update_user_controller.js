var app = angular.module('sixdegrees.controllers', []);

app.controller('UpdateUserCtrl', ['$scope', function($scope) {
  $scope.showPassword = false;
  $scope.showCancelAccount = false;
}]);