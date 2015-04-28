(function() {
  'use strict';
  define(['require', "q", "underscore", 'promise!modules/injector', 'modules/default_sync_config', 'modules/utils', 'modules/handlers/event_handler', 'modules/handlers/transmission_handler', 'modules/handlers/storage_handler'], function(require, Q, _, Injector, default_sync_config, Utils, Transmission, EventHandler, Storage) {
    var config, local, localDeferred, mainDeferred, promises, reset, save, sync, syncDeferred, test;
    reset = function(type) {
      if (type === 'local') {
        return Transmission.sendWait('Neo', 'OSN:ConfigGet').then(function(result) {
          return config.set('local', result.data);
        });
      } else if (type === 'sync') {
        return config.set('sync', default_sync_config);
      }
    };
    test = function(type, data) {
      var storage_map;
      storage_map = {
        local: {
          netflix: ['APIKey', 'APIRoot', 'authURL', 'domain', 'isSecure', 'pages', 'serverDefs']
        },
        sync: {
          controls: ['up', 'down', 'left', 'right', 'enter', 'cancel']
        }
      };
      return Utils.verifyObjectByMap(data, storage_map[type]);
    };
    save = function(result) {
      var data, k, type, v, _results;
      type = result[0];
      data = result[1];
      config[type] = {};
      _results = [];
      for (k in data) {
        v = data[k];
        _results.push(config[type][k] = v);
      }
      return _results;
    };
    config = {
      resetNetflix: function() {
        return reset('local');
      },
      resetControls: function() {
        return reset('sync');
      },
      set: function(type, data) {
        return Storage.set(type, data).then(function(result) {
          return save(result);
        });
      },
      get: function(type) {
        var deferred;
        deferred = Q.defer();
        Storage.get(type).then(function(result) {
          var data;
          data = result[1];
          if (test(type, data)) {
            return deferred.resolve([type, data]);
          } else {
            return deferred.reject(type);
          }
        });
        return deferred.promise;
      }
    };
    mainDeferred = Q.defer();
    promises = [];
    localDeferred = Q.defer();
    syncDeferred = Q.defer();
    promises.push(localDeferred.promise, syncDeferred.promise);
    local = config.get('local').then(save, reset).then(function(data) {
      return syncDeferred.resolve(true);
    });
    sync = config.get('sync').then(save, reset).then(function(data) {
      return syncDeferred.resolve(true);
    });
    Q.all([local, sync]).then(function(results) {
      return mainDeferred.resolve(config);
    });
    return mainDeferred.promise;
  });

}).call(this);
