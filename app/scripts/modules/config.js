(function() {
  'use strict';
  define(["jquery", "q", "underscore"], function($, Q, _, TransmissionHandler) {
    var Constants;
    return Constants = (function() {
      function Constants() {}

      Constants.keys = ['domain', 'pages', 'isSecure', 'authURL', 'serverDefs', 'APIRoot', 'APIKey', 'loading'];

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
          console.log('saving data not complete');
          return Constants.msg.transmit('MajorTom', 'OSN:Constants', 'fetch');
        }
      };

      return Constants;

    })();
  });

}).call(this);
