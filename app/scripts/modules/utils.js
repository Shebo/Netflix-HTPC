(function() {
  'use strict';
  define(["q"], function(Q) {
    var Utils;
    return Utils = (function() {
      function Utils() {}

      Utils.getObjectKeyInArray = function(array, object) {
        var el, i, _i, _len;
        for (i = _i = 0, _len = array.length; _i < _len; i = ++_i) {
          el = array[i];
          if (el === object) {
            return i;
          }
        }
        return false;
      };

      Utils.isJson = function(str) {
        var e;
        try {
          JSON.parse(str);
        } catch (_error) {
          e = _error;
          return false;
        }
        return true;
      };

      Utils.injectScript = function(path) {
        var script;
        script = document.createElement("script");
        script.src = chrome.extension.getURL(path);
        return document.head.appendChild(script);
      };

      Utils.rawAjax = function(url) {
        var deferred, request;
        request = new XMLHttpRequest();
        deferred = Q.defer();
        request.open('GET', url, true);
        request.onload = function() {
          var result;
          if (request.status === 200) {
            result = Utils.isJson(request.responseText) ? JSON.parse(request.responseText) : request.responseText;
            return deferred.resolve(result);
          } else {
            return deferred.reject(request.status);
          }
        };
        request.onerror = function() {
          return deferred.reject(request.status);
        };
        request.onprogress = function() {
          return deferred.notify(event.loaded / event.total);
        };
        request.send();
        return deferred.promise;
      };

      return Utils;

    })();
  });

}).call(this);
