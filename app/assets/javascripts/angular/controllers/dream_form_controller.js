var app = angular.module('sixdegrees');

app.controller('DreamFormCtrl', ['$scope', '$element', function($scope, $element) {
  $(document).ready(function() {
    $('input#dream_description').characterCounter();
  });
}]);