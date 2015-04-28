(function() {
  'use strict';
  define(["jquery", "q", "underscore", "modules/handlers/transmission_handler", "modules/local_config"], function($, Q, _, TransmissionHandler, Config) {
    var Constants, config, data, deferred;
    deferred = Q.defer();
    data = '';
    config = {
      set: function(type, name, data) {
        return Config.set(type, name, data).then(function() {
          return Config.get().then(function(data) {
            return config.get = function() {
              return data;
            };
          });
        });
      }
    };
    Config.get().then(function(data) {
      config.get = function() {
        return data;
      };
      return deferred.resolve(config);
    });
    return deferred.promise;
    return Constants = (function() {
      function Constants() {}

      Constants.keys = ['domain', 'pages', 'isSecure', 'authURL', 'serverDefs', 'APIRoot', 'APIKey', 'loading'];

      deferred = Q.defer();

      Config.get().then(function(data) {
        return deferred.resolve(data);
      });

      Constants.msg = new TransmissionHandler('GroundControl');

      chrome.storage.local.get(function(data) {
        return Constants.save(data);
      });

      $(document).on("OSN:Constants", function(e) {
        if (e.action === 'update') {
          return chrome.storage.local.set(e.info, function() {
            return Constants.save(e.info);
          });
        }
      });

      deferred.promise;

      Constants.save = function(data) {
        var k, v;
        console.log('saving data', data);
        for (k in data) {
          v = data[k];
          Constants[k] = v;
        }
        if (_.isEmpty(_.difference(Constants.keys, _.keys(data)))) {
          return Constants.loading = false;
        } else {
          return console.log('saving data not complete');
        }
      };

      return Constants;

    })();
  });

}).call(this);

//# sourceURL=modules\constants.js
//# sourceURL=constants.js
//# sourceURL=app/scripts/modules/constants.js