(function() {
  'use strict';
  define(["q", "underscore"], function(Q, _) {
    var Config;
    return Config = (function() {
      function Config() {}

      Config.get = function() {
        var deferred, local, promises, sync;
        deferred = Q.defer();
        promises = [];
        local = Q.defer();
        sync = Q.defer();
        promises.push(local.promise);
        promises.push(sync.promise);
        chrome.storage.local.get(function(data) {
          return local.resolve(data);
        });
        chrome.storage.sync.get(function(data) {
          return sync.resolve(data);
        });
        Q.spread(promises, function(local, sync) {
          console.log('done with config');
          return deferred.resolve(_.extend(local, sync));
        });
        return deferred.promise;
      };

      Config.set = function(type, names, data) {
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
        storage.set({
          names: data
        }, function() {
          return deferred.resolve(data);
        });
        return deferred.promise;
      };

      return Config;

    })();
  });

}).call(this);

//# sourceURL=modules\handlers\storageHandler.js
//# sourceURL=storageHandler.js
//# sourceURL=app/scripts/modules/handlers/storageHandler.js