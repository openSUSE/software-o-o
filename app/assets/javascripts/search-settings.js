/**
 * Control search settings modal.
 * - Settings will be stored in Cookies, not shown in URL anymore.
 * - Clicking OK button refresh current page.
 * - Clicking Cancel or x button do nothing.
 */
$(function() {
  var $modal = $("#search-settings");
  var $form = $("#baseproject");
  var $ok = $modal.find(".ok-button");
  var $cancel = $modal.find(".cancel-button");

  function save_input_cookie(name) {
    var value = $form.val();
    console.log(name + ": " + value);
    Cookies.set(name, value, { expires: 365 });
  }
  
  $form.on('change', function() {
    save_input_cookie("baseproject");
    location.reload();
  });

  function save_checkbox_cookie(name) {
    var value = $modal.find('[name="' + name + '"]').prop("checked");
    console.log(name + ": " + value);
    Cookies.set(name, value, { expires: 365 });
  }

  $ok.click(function() {
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
