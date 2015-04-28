(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['q', 'modules/handlers/event_handler', 'modules/utils'], function(Q, EventHandler, Utils) {
    var TransmissionHandler;
    return TransmissionHandler = (function(_super) {
      __extends(TransmissionHandler, _super);

      function TransmissionHandler() {
        return TransmissionHandler.__super__.constructor.apply(this, arguments);
      }

      window.addEventListener('message', TransmissionHandler._recieve);

      TransmissionHandler.sendAndWait = function(source, target, type, data) {
        var deferred, uniqueId;
        if (data == null) {
          data = void 0;
        }
        console.log('rrr');
        deferred = Q.defer();
        uniqueId = Utils.getUniqueId();
        window.postMessage({
          uniqueId: uniqueId,
          sender: source,
          recipient: target,
          type: type,
          data: data
        }, '*');
        document.addEventListener(uniqueId, function(e) {
          document.removeEventListener(uniqueId, arguments.callee);
          return deferred.resolve(e);
        });
        return deferred.promise;
      };

      TransmissionHandler.sendAndForget = function(source, target, type, action, data) {
        var uniqueId;
        if (data == null) {
          data = void 0;
        }
        uniqueId = Utils.getUniqueId();
        window.postMessage({
          uniqueId: uniqueId,
          sender: source,
          recipient: target,
          action: action,
          type: type,
          data: data
        }, '*');
        return uniqueId;
      };

      TransmissionHandler._recieve = function(event) {
        var msg;
        msg = event.data;
        if (msg.recipient === TransmissionHandler.source) {
          return TransmissionHandler.dispatch(msg.type, msg.action, msg.data);
        }
      };

      return TransmissionHandler;

    })(EventHandler);
  });

}).call(this);
