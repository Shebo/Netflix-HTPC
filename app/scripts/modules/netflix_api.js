(function() {
  'use strict';
  define(["require", "jquery", "q", "watch", 'modules/utils', 'promise!modules/config', 'modules/handlers/event_handler'], function(require, $, Q, WatchJS, Utils, Config, EventHandler) {
    var NetflixAPI, isRelative;
    WatchJS.watch(Config.local.netflix, function(prop, action, newvalue, oldvalue) {
      return NetflixAPI.conf = this;
    });
    isRelative = true;
    NetflixAPI = (function() {
      function NetflixAPI() {}

      NetflixAPI.conf = Config.local.netflix;

      NetflixAPI.root = !isRelative ? "" + (NetflixAPI.conf.isSecure ? "https" : "http") + "://" + NetflixAPI.conf.domain + "/" : '';

      NetflixAPI.APIRoot = "" + NetflixAPI.root + "/" + NetflixAPI.conf.APIRoot + "/" + NetflixAPI.conf.APIKey;

      NetflixAPI.getMovieInfo = function(movieID, trackID, jquery, type) {
        if (jquery == null) {
          jquery = true;
        }
        if (type == null) {
          type = 'shakti';
        }
        if (jquery) {
          return $.getJSON("" + this.root + "/" + this.conf.APIRoot + "/" + this.conf.APIKey + "/bob", {
            titleid: movieID,
            trackid: trackID,
            authURL: this.conf.authURL
          });
        } else {
          return Utils.rawAjax("" + this.root + "/" + this.conf.APIRoot + "/" + this.conf.APIKey + "/bob?titleid=" + movieID + "&trackid=" + trackID + "&authURL=" + this.conf.authURL);
        }
      };

      return NetflixAPI;

    })();
    return NetflixAPI.getMovieInfo(1, 1).fail(function(error) {
      if (error.status === 404 || error.status === 0) {
        console.log('need to update', Config);
        return Config.resetNetflix().then(function(data) {
          return NetflixAPI.conf = Config.local.netflix;
        });
      }
    });
  });

}).call(this);
