(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["jquery", "watch", "KeyboardJS", 'promise!modules/config', 'modules/handlers/event_handler'], function($, WatchJS, KeyboardJS, Config, EventHandler) {
    var ActionHandler, isAllowed;
    isAllowed = true;
    WatchJS.watch(Config.local.netflix, function(prop, action, newvalue, oldvalue) {
      return NetflixAPI.conf = this;
    });
    return ActionHandler = (function(_super) {
      __extends(ActionHandler, _super);

      function ActionHandler() {
        return ActionHandler.__super__.constructor.apply(this, arguments);
      }

      ActionHandler.controls = Config.sync.controls;

      ActionHandler._initShortcuts = function() {
        var action, combo, _ref, _results;
        _ref = ActionHandler.controls;
        _results = [];
        for (action in _ref) {
          combo = _ref[action];
          _results.push(ActionHandler._bindShortcuts(action, combo));
        }
        return _results;
      };

      ActionHandler._initActionBlocker = function() {
        ActionHandler.isAllowed = true;
        $(":input").focus(function(e) {
          return ActionHandler.isAllowed = false;
        });
        return $(":input").blur(function(e) {
          return ActionHandler.isAllowed = true;
        });
      };

      ActionHandler._bindShortcuts = function(action, combo) {
        return KeyboardJS.on(combo, function(e) {
          if (ActionHandler.isAllowed) {
            return ActionHandler.fire('OSN:Controls', {
              action: action
            });
          }
        });
      };

      ActionHandler._initShortcuts();

      ActionHandler._initActionBlocker();

      return ActionHandler;

    })(EventHandler);
  });

}).call(this);
