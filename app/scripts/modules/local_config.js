(function() {
  'use strict';
  define(["jquery", "q", "underscore"], function($, Q, _) {
    var deferred, local, promises, sync;
    deferred = Q.defer();
    local = Q.defer();
    sync = Q.defer();
    promises = [];
    promises.push(local.promise);
    promises.push(sync.promise);
    chrome.storage.local.get((function(_this) {
      return function(data) {
        console.log('local', data);
        local.resolve(data);
        return true;
      };
    })(this));
    chrome.storage.sync.get((function(_this) {
      return function(data) {
        console.log('sync', data);
        sync.resolve(data);
        return true;
      };
    })(this));
    Q.spread(promises, function(local, sync) {
      console.log('spread', _.extend(local, sync));
      return deferred.resolve(_.extend(local, sync));
    });
    return deferred.promise;
  });

}).call(this);
