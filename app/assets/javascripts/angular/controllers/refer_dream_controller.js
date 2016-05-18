var app = angular.module('sixdegrees');

app.controller('ReferDreamCtrl', ['$scope', '$element', function($scope, $element) {
  var dialogDuration = 4000

  $element.on("click", ".send-referral-button", function(e) {
    e.preventDefault()

    var sendButton = $element.find(".send-referral-button")
    var referrerInput = $element.find("#referral_referrer_name")
    var referrerName = referrerInput.val()
    var emailInput = $element.find("#referral_email")
    var email = emailInput.val()

    sendButton.addClass("disabled")

    if (referrerName == "") {
      referrerInput.focus()
      Materialize.toast("Please fill in all fields", dialogDuration)
    } else if (email == "") {
      emailInput.focus()
      Materialize.toast("Please fill in all fields", dialogDuration)
    } else if (!validateEmail(email)) {
      emailInput.focus()
      Materialize.toast("Please enter a correct email", dialogDuration)
    } else if (!validateKellogg(email.toLowerCase())) {
      emailInput.focus()
      Materialize.toast("Please enter a @kellogg.northwestern.edu address", dialogDuration)
    } else {
      var form = $element.find("form")
      var url = form.attr("action")
      $.ajax({
        url: url,
        method: "POST",
        data: form.serialize()
      })
      .done(function(result) {
        emailInput.val("")
        $element.closeModal()
      })
    }
    sendButton.removeClass("disabled")
  });

  function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  function validateKellogg(email) {
    var re = /@kellogg.northwestern.edu\s*$/
    return re.test(email);
  }
}]);