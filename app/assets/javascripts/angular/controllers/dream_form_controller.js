var app = angular.module('sixdegrees');

app.controller('DreamFormCtrl', ['$scope', '$element', function($scope, $element) {
  var dialogTime = 4000
  
  $(document).ready(function() {
    $('input#dream_description').characterCounter();
  });

  $element.on("click", ".create-update-dream-button", function(e) {
    e.preventDefault()
    var descriptionBox = $element.find("#dream_description")
    var limit = parseInt(descriptionBox.attr("length"))
    var textLength = descriptionBox.val().length
    if (textLength > limit) {
      Materialize.toast("Dream is too long!", dialogTime)
      descriptionBox.focus()
    } else {
      $element.find("form").submit()
    }
  })
}]);