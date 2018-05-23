/**
 * Control search settings modal.
 * - Settings will be stored in Cookies, not shown in URL anymore.
 * - Clicking OK button refresh current page.
 * - Clicking Cancel or x button do nothing.
 */
$(function() {
  var $modal = $("#search-settings");
  var $form = $modal.find("form");
  var $ok = $modal.find(".ok-button");
  var $cancel = $modal.find(".cancel-button");

  // For fresh new system, popup modal and let users choose their system version
  if (!Cookies.get("baseproject")) {
    $modal.modal("show");
  }

  function save_input_cookie(name) {
    var value = $form.find('[name="' + name + '"]').val();
    console.log(name + ": " + value);
    Cookies.set(name, value, { expires: 365 });
  }

  function save_checkbox_cookie(name) {
    var value = $form.find('[name="' + name + '"]').prop("checked");
    console.log(name + ": " + value);
    Cookies.set(name, value, { expires: 365 });
  }

  $ok.click(function() {
    save_input_cookie("baseproject");
    save_checkbox_cookie("search_devel");
    save_checkbox_cookie("search_lang");
    save_checkbox_cookie("search_debug");
    $modal.modal("hide");
    location.reload();
  });
  $cancel.click(function() {
    $form[0].reset();
    $modal.modal("hide");
  });
});
