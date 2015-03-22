$(document).ready(function() {
  // Javascript to enable link to tab
  var hash = document.location.hash;
  var prefix = "tab_";
  if (hash) {
    $('.nav-pills a[href='+hash.replace(prefix,"")+']').tab('show');
    window.scrollTo(0,0)
  } 

  // Change hash for page-reload
  $('.nav-pills a').on('shown.bs.tab', function (e) {
    window.location.hash = e.target.hash.replace("#", "#" + prefix);
    window.scrollTo(0,0)
  });
})