/**
 * Control search settings modal.
 * - Settings will be stored in Cookies, not shown in URL anymore.
 * - Clicking OK button refresh current page.
 * - Clicking Cancel or x button do nothing.
 */
$(function() {
  var $modal = $("#search-settings");
  var $ok = $modal.find(".ok-button");
  var $cancel = $modal.find(".cancel-button");

  $modal.modal();
  // For fresh new system, popup modal and let users choose their system version
  if (!Cookies.get("search_baseproject")) {
    $modal.modal("show");
  }
});
