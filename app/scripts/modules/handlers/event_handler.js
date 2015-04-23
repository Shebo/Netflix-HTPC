(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(["jquery"], function($) {
    var EventHandler;
    return EventHandler = (function() {
      function EventHandler() {
        this._safeDispatch = __bind(this._safeDispatch, this);
        this.dispatch = __bind(this.dispatch, this);
      }

      EventHandler.prototype.dispatch = function(type, action, info) {
        var dispatchInterval;
        if (info == null) {
          info = void 0;
        }
        if ($ != null) {
          return this._safeDispatch(type, action, info);
        } else {
          return dispatchInterval = setInterval(function() {
            if ($ != null) {
              clearInterval(dispatchInterval);
              return this._safeDispatch(type, action, info);
            }
          }, 10);
        }
      };

      EventHandler.prototype._safeDispatch = function(type, action, info) {
        $.event.trigger({
          type: type,
          action: action,
          info: info
        });
        return false;
      };

      return EventHandler;

    })();
  });

}).call(this);
