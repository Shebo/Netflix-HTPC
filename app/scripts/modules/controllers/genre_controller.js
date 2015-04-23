(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["modules/controllers/grid_controller", "modules/selectors/genre_selectors"], function(GridController, GenreSelectors) {
    var GenreController;
    return GenreController = (function(_super) {
      __extends(GenreController, _super);

      function GenreController() {
        this.HTML = GenreSelectors;
        GenreController.__super__.constructor.call(this, this.HTML);
      }

      return GenreController;

    })(GridController);
  });

}).call(this);
