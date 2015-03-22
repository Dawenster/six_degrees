var app = angular.module('sixdegrees.services', []);

app.factory("Connections", function() {
  var Connections = {};

  Connections.updateStatus = function(url) {
    $.ajax({
      url: url,
      method: "put"
    })
  }

  return Connections;
});