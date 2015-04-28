(function() {
  'use strict';
  var iFrame;

  iFrame = document.createElement("iframe");

  iFrame.src = chrome.extension.getURL("optionsttt.html");

  document.body.insertBefore(iFrame, document.body.firstChild);

}).call(this);
