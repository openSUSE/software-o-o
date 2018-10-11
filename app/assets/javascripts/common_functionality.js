// Preselect a tab when it's referenced in url
$(document).ready(function () {
  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');
});
