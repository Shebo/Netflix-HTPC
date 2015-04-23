(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["jquery", "KeyboardJS", 'modules/handlers/event_handler'], function($, KeyboardJS, EventHandler) {
    var ActionHandler;
    return ActionHandler = (function(_super) {
      __extends(ActionHandler, _super);

      function ActionHandler() {
        this._bindShortcuts = __bind(this._bindShortcuts, this);
        this._initActionBlocker = __bind(this._initActionBlocker, this);
        this._initShortcuts = __bind(this._initShortcuts, this);
        ActionHandler.__super__.constructor.apply(this, arguments);
        this.actions = ['left', 'up', 'right', 'down', 'ok', 'cancel'];
        this._initShortcuts();
        this._initActionBlocker();
      }

      ActionHandler.prototype._initShortcuts = function() {
        return chrome.storage.sync.get(this.actions, (function(_this) {
          return function(shortcuts) {
            var action, combo;
            for (action in shortcuts) {
              combo = shortcuts[action];
              _this._bindShortcuts(action, combo);
            }
            return true;
          };
        })(this));
      };

      ActionHandler.prototype._initActionBlocker = function() {
        this.isAllowed = true;
        $(":input").focus((function(_this) {
          return function(e) {
            return _this.isAllowed = false;
          };
        })(this));
        return $(":input").blur((function(_this) {
          return function(e) {
            return _this.isAllowed = true;
          };
        })(this));
      };

      ActionHandler.prototype._bindShortcuts = function(action, combo) {
        return KeyboardJS.on(combo, (function(_this) {
          return function(e) {
            if (_this.isAllowed) {
              return _this.dispatch('OSN:Controls', action);
            }
          };
        })(this));
      };

      return ActionHandler;

    })(EventHandler);
  });

}).call(this);
