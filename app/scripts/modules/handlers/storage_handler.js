(function() {
  'use strict';
  define(["q", "underscore"], function(Q, _) {
    var Config;
    return Config = (function() {
      function Config() {}

      Config.get = function(type, names) {
        var deferred, storage;
        if (names == null) {
          names = null;
        }
        deferred = Q.defer();
        switch (type) {
          case 'sync':
            storage = chrome.storage.sync;
            break;
          case 'local':
            storage = chrome.storage.local;
            break;
          default:
            null;
        }
        storage.get(names, function(data) {
          return deferred.resolve([type, data]);
        });
        return deferred.promise;
      };

      Config.set = function(type, data) {
        var deferred, storage;
        deferred = Q.defer();
        switch (type) {
          case 'sync':
            storage = chrome.storage.sync;
            break;
          case 'local':
            storage = chrome.storage.local;
            break;
          default:
            null;
        }
        storage.set(data, function() {
          return deferred.resolve([type, data]);
        });
        return deferred.promise;
      };

      return Config;

    })();
  });

}).call(this);
