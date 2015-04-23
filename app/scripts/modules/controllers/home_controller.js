(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["modules/controllers/grid_controller", "modules/selectors/home_selectors"], function(GridController, HomeSelectors) {
    var HomeController;
    return HomeController = (function(_super) {
      __extends(HomeController, _super);

      function HomeController() {
        this.HTML = HomeSelectors;
        HomeController.__super__.constructor.call(this, this.HTML);
      }

      return HomeController;

    })(GridController);
  });

}).call(this);
