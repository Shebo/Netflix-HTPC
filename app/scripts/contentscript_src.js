(function() {
  'use strict';
  require.config({
    baseUrl: chrome.extension.getURL('scripts'),
    waitSeconds: 60,
    shim: {
      simulate: 'jquery',
      bootstrap: 'jquery'
    },
    paths: {
      promise: '../bower_components/requirejs-promise/requirejs-promise',
      jquery: '../bower_components/jquery/dist/jquery',
      q: '../bower_components/q/q',
      watch: '../bower_components/watch/src/watch',
      simulate: '../bower_components/jquery-simulate/jquery-simulate',
      underscore: '../bower_components/underscore/underscore',
      bootstrap: '../bower_components/bootstrap/dist/js/bootstrap',
      KeyboardJS: '../bower_components/KeyboardJS/keyboard',
      gamepad: '../bower_components/HTML5-JavaScript-Gamepad-Controller-Library/gamepad'
    },
    packages: []
  });

  require(['q', 'modules/netflix_api', 'modules/utils', 'modules/handlers/action_handler', 'modules/handlers/transmission_handler', 'modules/controllers/home_controller', 'modules/controllers/genre_controller'], function(Q, NetflixAPI, Utils, ActionHandler, TransmissionHandler, HomeController, GenreController) {
    var controller;
    console.log('Config2222');
    if (window.location.pathname.match("/WiHome")) {
      return controller = new HomeController;
    } else if (window.location.pathname.match("/WiGenre")) {
      return controller = new GenreController;
    }
  });

  chrome.extension.sendMessage({}, function(response) {
    var readyStateCheckInterval;
    readyStateCheckInterval = setInterval(function() {
      if (document.readyState === "complete") {
        clearInterval(readyStateCheckInterval);
        console.log("Hello. This message was sent from scripts/inject.jasds");
      }
    }, 10);
  });

}).call(this);
