/**
 * Control search settings modal.
 * - Settings will be stored in Cookies, not shown in URL anymore.
 * - Clicking OK button refresh current page.
 * - Clicking Cancel or x button do nothing.
 */
$(function() {
  var $settings_modal = $("#search-settings");
  var $project_dropdown = $("#baseproject");
  var $ok = $settings_modal.find(".ok-button");
  var $cancel = $settings_modal.find(".cancel-button");

  function set_cookie(name, value) {
    console.log("Setting cookie: " + name + " = " + value);
    Cookies.set(name, value, { expires: 365 });
  }

  $project_dropdown.on('change', function() {
    /*
     * See https://stackoverflow.com/a/41542008 for editing query string
     */
    var value = $project_dropdown.val();
    var query_params = new URLSearchParams(window.location.search);

    set_cookie("baseproject", value);
    if (query_params.has("baseproject")) query_params.set("baseproject", value);

    // causes site reload
    window.location.search = query_params.toString();
  });

  $ok.click(function() {
    for (setting of ["search_devel", "search_lang", "search_debug"]) {
      var value = $settings_modal.find('[name="'+ setting +'"]').prop("checked");
      set_cookie(setting, value);
    }
    location.reload();
  });

  $cancel.click(function() {
    $settings_modal.find('form')[0].reset();
    $settings_modal.modal("hide");
  });
});
