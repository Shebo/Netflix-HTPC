(function() {
  'use strict';
  require.config({
    baseUrl: chrome.extension.getURL('scripts'),
    shim: {
      simulate: 'jquery',
      bootstrap: 'jquery'
    },
    paths: {
      promise: '../bower_components/requirejs-promise/requirejs-promise',
      jquery: '../bower_components/jquery/dist/jquery',
      q: '../bower_components/q/q',
      simulate: '../bower_components/jquery-simulate/jquery-simulate',
      underscore: '../bower_components/underscore/underscore',
      bootstrap: '../bower_components/bootstrap/dist/js/bootstrap',
      KeyboardJS: '../bower_components/KeyboardJS/keyboard',
      gamepad: '../bower_components/HTML5-JavaScript-Gamepad-Controller-Library/gamepad'
    },
    packages: []
  });

  require(['q', 'modules/constants', 'modules/netflix_api', 'modules/utils', 'modules/handlers/action_handler', 'modules/handlers/transmission_handler', 'modules/controllers/home_controller', 'modules/controllers/genre_controller'], function(Q, Constants, NetflixAPI, Utils, ActionHandler, TransmissionHandler, HomeController, GenreController) {
    var actionHandler, controller, msg, testAPI;
    msg = new TransmissionHandler('GroundControl');
    actionHandler = new ActionHandler;
    if (window.location.pathname.match("/WiHome")) {
      controller = new HomeController;
    } else if (window.location.pathname.match("/WiGenre")) {
      controller = new GenreController;
    }
    testAPI = function(movieID, trackID) {
      var deferred, loadedConstantsInterval;
      deferred = Q.defer();
      constants.loaded().then(function(data) {
        return deferred.resolve(NetflixAPI.getMovieInfo(movieID, trackID, false));
      }, function(error) {
        return deferred.reject(0);
      });
      if (Constants.loaded) {
        deferred.resolve(NetflixAPI.getMovieInfo(movieID, trackID, false));
      } else {
        loadedConstantsInterval = setInterval(function() {
          if (typeof Constants.loaded === 'boolean') {
            clearInterval(loadedConstantsInterval);
            if (!Constants.loaded) {
              return deferred.resolve(NetflixAPI.getMovieInfo(movieID, trackID, false));
            }
          }
        }, 10);
      }
      deferred.promise;
      return true;
    };
    return testAPI('70180183', '13462047').fail(function(error) {
      if (error === 404 || error === 0) {
        return msg.transmit('MajorTom', 'OSN:Constants', 'fetch');
      }
    });
  });

  chrome.extension.sendMessage({}, function(response) {
    var readyStateCheckInterval;
    readyStateCheckInterval = setInterval(function() {
      var movie;
      if (document.readyState === "complete") {
        clearInterval(readyStateCheckInterval);
        console.log("Hello. This message was sent from scripts/inject.jasds");
        movie = $('.agMovie.agMovie-lulg').first().find("a");
        $(".gallery").bind("DOMNodeInserted", function() {
          return console.log("child is appended");
        });
      }
    }, 10);
  });

}).call(this);
