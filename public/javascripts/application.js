// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var divs_shown = false;
function toggleAllDebugDivs() {
  var divs = Element.getElementsBySelector($('result'), 'div[class="debug"]');
  var text = $('showdebug').firstChild
  if(divs_shown) {
    Element.replace(text, "Show debugging info");
    divs_shown = false;
  } else {
    Element.replace(text, "Hide debugging info");
    divs_shown = true;
  }

  divs.each(Element.toggle);
}


function setCookie(name, value) {
  document.cookie = name + "=" + value + "; path=/";
}

function getCookie(name) {
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i < ca.length; ++i) {
    var c = ca[i];
    while (c.charAt(0)==' ')
      c = c.substring(1,c.length);
    if (c.indexOf(nameEQ) == 0)
      return c.substring(nameEQ.length,c.length);
  }
  return null;
}

function submitquery() {
  $("#q").attr('value', $(this).text());
  $("#search_form > form").submit();
}

$(function() {
  $(".query").click(submitquery);
});

