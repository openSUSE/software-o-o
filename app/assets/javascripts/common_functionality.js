// Preselect a tab when it's referenced in url
$(document).ready(function () {
  let hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');
});
