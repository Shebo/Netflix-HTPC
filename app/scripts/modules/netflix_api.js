(function() {
  'use strict';
  define(["jquery", "q", 'modules/utils', 'modules/constants'], function($, Q, Utils, Constants) {
    var NetflixAPI;
    return NetflixAPI = (function() {
      function NetflixAPI() {}

      NetflixAPI.isRelative = true;

      NetflixAPI._getRoot = function() {
        if (!NetflixAPI.isRelative) {
          return "" + (Constants.isSecure ? "https" : "http") + "://" + Constants.domain + "/";
        } else {
          return '';
        }
      };

      NetflixAPI._getAPIRoot = function() {
        return "" + (NetflixAPI._getRoot()) + "/" + Constants.APIRoot + "/" + Constants.APIKey;
      };

      NetflixAPI.getMovieInfo = function(movieID, trackID, jquery, type) {
        if (jquery == null) {
          jquery = true;
        }
        if (type == null) {
          type = 'shakti';
        }
        if (jquery) {
          return Q($.getJSON("" + (this._getRoot()) + "/" + Constants.APIRoot + "/" + Constants.APIKey + "/bob", {
            titleid: movieID,
            trackid: trackID,
            authURL: Constants.authURL
          }));
        } else {
          return Utils.rawAjax("" + (this._getRoot()) + "/" + Constants.APIRoot + "/" + Constants.APIKey + "/bob?titleid=" + movieID + "&trackid=" + trackID + "&authURL=" + Constants.authURL);
        }
      };

      return NetflixAPI;

    })();
  });

}).call(this);
