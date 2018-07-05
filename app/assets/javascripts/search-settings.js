/**
 * Control search form interaction
 */
$(function() {
  var $form = $("#search-form");

  $form.find('[name="baseproject"]').change(function() {
    Cookies.set("baseproject", $(this).val(), { expires: 365 });
    location.reload();
  });

  ["search_devel", "search_lang", "search_debug"].map(function(name) {
    $form.find('[name="' + name + '"]').change(function() {
      Cookies.set(name, $(this).prop("checked"), { expires: 365 });
      location.reload();
    });
  });
});
