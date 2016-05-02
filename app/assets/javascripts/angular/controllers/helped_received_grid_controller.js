var app = angular.module('sixdegrees');

app.controller('HelpedReceivedGridCtrl', ['$scope', "Connections", '$element', function($scope, Connections, $element) {
  $scope.updateStatus = function(url) {
    Connections.updateStatus(url)
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

  $("body").on("click", ".accept-button", function() {
    var url = $(this).attr("data-fetch-email-url")
    var element = $(this)
    $.ajax({
      url: url,
      method: "get"
    })
    .done(function(result) {
      var emailSection = element.parents(".card").find(".display-email-section")
      emailSection.removeClass("hide")
      emailSection.html(result.email_display)
      element.parents(".card").find(".accepted-actions").removeClass("hide")
      element.parents(".card").find(".pre-accepted-actions").addClass("hide")
    })
  });

  $("body").on("click", ".decline-button", function() {
    $(this).parents(".card").find(".buttons-holder").addClass("hide")
    $(this).parents(".card").find(".pre-accepted-actions").addClass("hide")
  });

  $("body").on("click", ".pre-accepted-actions a", function() {
    if ($(this).hasClass("accept-button")) {
      $(this).parents(".card").find(".accepted-holder").removeClass("hide")
    } else {
      $(this).parents(".card").find(".declined-holder").removeClass("hide")
    }
    $(this).parent().hide()
  });

  $("body").on("click", ".show-email-link", function() {
    $(this).parent().hide()
    $(this).parent().siblings(".email-as-text").show()
  });

  $element.on("click", ".give-kudos-button", function() {
    var url = $(this).data("kudos-url")
    $.ajax({
      url: url,
      method: "POST",
      data: {
        giver_id: $(this).data("giver-id"),
        receiver_id: $(this).data("receiver-id")
      }
    })
    .done(function(result) {
      $element.find(".buttons-holder").addClass("hide")
    })
  });
}]);