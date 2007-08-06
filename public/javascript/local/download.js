/*
*
* JavaScript functions for download.opensuse.org
* Author: Frank Sundermeyer <fs@opensuse.org>
* $Id: $
*/

// Make hidden portion visible if JS is activated

function downloadShow () {
  document.getElementById('script_only').className = 'show';
}

// Hide BitTorrent option on Mini CD downloads

function toggleBitTorrent () {
  var NETWORK_BUTTON = document.forms["download"].elements["media_type"][2];
  var TORRENT_BUTTON = document.getElementById('l_torrent');
  var PROTOCOL_RADIO = document.forms["download"].elements["protocol"];
  if (NETWORK_BUTTON.checked ) {
    TORRENT_BUTTON.style.display = "none";
    PROTOCOL_RADIO[1].checked = true;
    PROTOCOL_RADIO[0].checked = false;
  } else {
    TORRENT_BUTTON.style.display = "inline";
    PROTOCOL_RADIO[0].checked = true;
    PROTOCOL_RADIO[1].checked = false;
  }
}   

// Display the download data base on arch, media, and method

function displayDownload () {
  /*
  * Get the ARCH value
  */
  var ARCH_RADIO = document.forms["download"].elements["arch"];
  var ARCH_RADIO_LENGTH = ARCH_RADIO.length;
  for (var i = 0; i < ARCH_RADIO_LENGTH; i++) {
    if (ARCH_RADIO[i].checked) {
      var ARCH = ARCH_RADIO[i].value;
      // Set class of parent lable element to selected
      var LABEL = "l_" + ARCH_RADIO[i].id;
      document.getElementById(LABEL).className = "selected";
    } else {
      // Set class of parent lable element to ""
      var LABEL = "l_" + ARCH_RADIO[i].id;
      document.getElementById(LABEL).className = "";
    }
  }
  /*
  * Get the MEDIATYPE value
  */
  var MEDIATYPE_RADIO = document.forms["download"].elements["media_type"];
  var MEDIATYPE_RADIO_LENGTH = MEDIATYPE_RADIO.length;
  for (var i = 0; i < MEDIATYPE_RADIO_LENGTH; i++) {
    if (MEDIATYPE_RADIO[i].checked) {
      var MEDIATYPE = MEDIATYPE_RADIO[i].value;
      // Set class of parent lable element to selected
      var LABEL = "l_" + MEDIATYPE_RADIO[i].id;
      document.getElementById(LABEL).className = "selected";
    } else {
      // Set class of parent lable element to ""
      var LABEL = "l_" +  MEDIATYPE_RADIO[i].id;
      document.getElementById(LABEL).className = "";
    }
  }
  /*
  * Get the PROTOCOL value
  */
  var PROTOCOL_RADIO = document.forms["download"].elements["protocol"];
  var PROTOCOL_RADIO_LENGTH = PROTOCOL_RADIO.length; 
  for (var i = 0; i < PROTOCOL_RADIO_LENGTH; i++) {
    if (PROTOCOL_RADIO[i].checked) {
      var PROTOCOL = PROTOCOL_RADIO[i].value;
      // Set class of parent lable element to selected
      var LABEL = "l_" + PROTOCOL_RADIO[i].id;
      document.getElementById(LABEL).className = "selected";
    } else {
      // Set class of parent lable element to ""
      var LABEL = "l_" +  PROTOCOL_RADIO[i].id;
      document.getElementById(LABEL).className = "";
    }
  }

  switchDisplay ();

  // The id of the media element to display
  var ID_TO_DISPLAY = ARCH + MEDIATYPE + PROTOCOL;

  // Show it
  document.getElementById(ID_TO_DISPLAY).className="show";

  return true; 
}

// Toggle visible/hidden parts - helper function for displayDownload

function switchDisplay () {
  var DOWNLOAD_SECT = document.getElementById ("download_links");
  var DOWNLOAD_SHOW = DOWNLOAD_SECT.getElementsByTagName ("div");
  var DOWNLOAD_SHOW_LENGTH = DOWNLOAD_SHOW.length;
  for (var i = 0; i < DOWNLOAD_SHOW_LENGTH; i++) {
    if (DOWNLOAD_SHOW[i].className == "show") {
      DOWNLOAD_SHOW[i].className="hide";
    }
  }
  return true;
}

// The Popup windows

var OPEN_POPUP = null;

function popup_close() {
  if (OPEN_POPUP && !OPEN_POPUP.closed) {
    OPEN_POPUP.close();
  }
}

function popup (URL,NAME,WIDTH,HEIGHT) {
  var PARAMS='width='+WIDTH+',height='+HEIGHT+',resizable,,menubar=no,toolbar=no,scrollbars';
  popup_close(); //close previously opened PopUps
  OPEN_POPUP=window.open(URL,NAME,PARAMS);
  if (OPEN_POPUP) {
    return false;
  } else {
    return true;
  }
}
