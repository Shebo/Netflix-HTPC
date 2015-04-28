(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['q', 'modules/handlers/event_handler', 'modules/utils'], function(Q, EventHandler, Utils) {
    var TransmissionHandler;
    return TransmissionHandler = (function(_super) {
      __extends(TransmissionHandler, _super);

      function TransmissionHandler() {
        return TransmissionHandler.__super__.constructor.apply(this, arguments);
      }

      TransmissionHandler.source = 'Nebuchadnezzar';

      TransmissionHandler._transmit = function(recipient, type, data, uniqueId) {
        console.log("" + TransmissionHandler.source + ": Transmission is out", {
          recipient: recipient,
          type: type,
          data: data,
          uniqueId: uniqueId
        });
        return window.postMessage({
          uniqueId: uniqueId,
          sender: TransmissionHandler.source,
          recipient: recipient,
          type: type,
          data: data
        }, '*');
      };

      TransmissionHandler._recieve = function(event) {
        if (event.data.recipient === TransmissionHandler.source) {
          console.log("" + TransmissionHandler.source + ": Transmission Recieved over", event);
          return TransmissionHandler.fire(event.data);
        }
      };

      TransmissionHandler.sendWait = function(recipient, type, data, uniqueId) {
        var deferred;
        if (data == null) {
          data = null;
        }
        if (uniqueId == null) {
          uniqueId = Utils.getUniqueId();
        }
        deferred = Q.defer();
        TransmissionHandler._transmit(recipient, type, data, uniqueId);
        TransmissionHandler.on(window, 'message', function(event) {
          if (event.recipient === TransmissionHandler.source && event.uniqueId === uniqueId) {
            TransmissionHandler.off(window, 'message', arguments.callee);
            console.log("" + TransmissionHandler.source + ": Transmission came back", event);
            return deferred.resolve(event);
          }
        });
        return deferred.promise;
      };

      TransmissionHandler.sendForget = function(recipient, type, data, uniqueId) {
        if (data == null) {
          data = null;
        }
        if (uniqueId == null) {
          uniqueId = Utils.getUniqueId();
        }
        TransmissionHandler._transmit(recipient, type, data, uniqueId);
        return uniqueId;
      };

      window.addEventListener('message', TransmissionHandler._recieve);

      return TransmissionHandler;

    })(EventHandler);
  });

}).call(this);
