(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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

      Utils.getUniqueId = function() {
        return Date.now();
      };

      Utils.verifyObjectByMap = function(obj, arr) {
        var key, value;
        for (key in obj) {
          value = obj[key];
          if (_.isObject(value)) {
            if (__indexOf.call(_.keys(arr), key) >= 0) {
              arr[key] = this.verifyObjectByMap(value, arr[key]);
              if (_.isEmpty(arr[key])) {
                delete arr[key];
              }
            }
          } else {
            if (__indexOf.call(arr, key) >= 0) {
              arr = _.without(arr, key);
            }
          }
        }
        return _.isEmpty(arr);
      };

      Utils.injectScript = function(path) {
        var deferred, script;
        deferred = Q.defer();
        script = document.createElement("script");
        script.src = chrome.extension.getURL(path);
        script.onload = function() {
          return deferred.resolve(true);
        };
        document.head.appendChild(script);
        return deferred.promise;
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
