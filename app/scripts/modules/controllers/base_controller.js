(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  define(["jquery"], function($) {
    var BaseController;
    return BaseController = (function() {
      function BaseController() {
        this.cancel = __bind(this.cancel, this);
        this.enter = __bind(this.enter, this);
        this.left = __bind(this.left, this);
        this.right = __bind(this.right, this);
        this.down = __bind(this.down, this);
        this.up = __bind(this.up, this);
        this.doAction = __bind(this.doAction, this);
        this.ACTIONS = {
          LEFT: 'left',
          RIGHT: 'right',
          UP: 'up',
          DOWN: 'down',
          OK: 'ok',
          CANCEL: 'cancel'
        };
        $(document).on("OSN:Controls", (function(_this) {
          return function(e) {
            return setTimeout(function() {
              console.log("jquery event:", e);
              return _this.doAction(e.action);
            }, 0);
          };
        })(this));
      }

      BaseController.prototype.doAction = function(action) {
        return console.log("Do " + action);
      };

      BaseController.prototype.up = function() {
        return console.log("up");
      };

      BaseController.prototype.down = function() {
        return console.log("down");
      };

      BaseController.prototype.right = function() {
        return console.log("right");
      };

      BaseController.prototype.left = function() {
        return console.log("left");
      };

      BaseController.prototype.enter = function() {
        return console.log("enter");
      };

      BaseController.prototype.cancel = function() {
        return console.log("cancel");
      };

      return BaseController;

    })();
  });

}).call(this);
