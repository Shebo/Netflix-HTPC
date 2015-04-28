(function() {
  'use strict';
  define([], function() {
    var EventHandler;
    return EventHandler = (function() {
      function EventHandler() {}

      EventHandler.fire = function(type, msg) {
        var evt;
        evt = new CustomEvent(type, {
          detail: msg
        });
        document.dispatchEvent(evt);
        return false;
      };

      EventHandler.on = function(type, callback) {
        document.addEventListener(type, function(e) {
          var eventData;
          eventData = e.detail ? e.detail : e.data;
          return callback(eventData);
        });
      };

      EventHandler.off = function(type, callback) {
        document.removeEventListener(type, callback);
      };

      EventHandler.one = function(type, callback) {
        EventHandler.on(type, function(e) {
          EventHandler.off(type, callback);
          return callback(e);
        });
      };

      return EventHandler;

    })();
  });

}).call(this);
