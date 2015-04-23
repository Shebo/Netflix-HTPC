(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['modules/handlers/event_handler'], function(EventHandler) {
    var TransmissionHandler;
    return TransmissionHandler = (function(_super) {
      __extends(TransmissionHandler, _super);

      function TransmissionHandler(source) {
        this._recieve = __bind(this._recieve, this);
        this.transmit = __bind(this.transmit, this);
        this.source = source;
        window.addEventListener('message', this._recieve);
      }

      TransmissionHandler.prototype.transmit = function(target, type, action, data) {
        if (data == null) {
          data = void 0;
        }
        return window.postMessage({
          sender: this.source,
          recipient: target,
          action: action,
          type: type,
          data: data
        }, '*');
      };

      TransmissionHandler.prototype._recieve = function(event) {
        var msg;
        msg = event.data;
        if (msg.recipient === this.source) {
          return this.dispatch(msg.type, msg.action, msg.data);
        }
      };

      return TransmissionHandler;

    })(EventHandler);
  });

}).call(this);
