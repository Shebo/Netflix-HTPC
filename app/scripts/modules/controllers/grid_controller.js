(function() {
  'use strict';
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["jquery", "underscore", 'modules/utils', 'modules/controllers/base_controller', 'modules/dom_manipulation', 'modules/models/list', 'modules/models/movie'], function($, _, Utils, BaseController, DomManipulation, List, Movie) {
    var GridController;
    return GridController = (function(_super) {
      __extends(GridController, _super);

      function GridController(HTMLSelectors) {
        this._updateMovie = __bind(this._updateMovie, this);
        this._updateList = __bind(this._updateList, this);
        this._prevList = __bind(this._prevList, this);
        this._nextList = __bind(this._nextList, this);
        this.gridMove = __bind(this.gridMove, this);
        this.mouseMove = __bind(this.mouseMove, this);
        this.right = __bind(this.right, this);
        this.down = __bind(this.down, this);
        this.up = __bind(this.up, this);
        this.left = __bind(this.left, this);
        this._getRowSize = __bind(this._getRowSize, this);
        this.doAction = __bind(this.doAction, this);
        GridController.__super__.constructor.apply(this, arguments);
        this.HTML = HTMLSelectors;
        this.lists = $(this.HTML.lists);
        this._updateList(0);
        this._updateMovie(0);
        $(window).resize(this._getRowSize);
        $(this.HTML.movies).mouseover(this.mouseMove);
      }

      GridController.prototype.doAction = function(action) {
        switch (action) {
          case this.ACTIONS.LEFT:
            return this.left();
          case this.ACTIONS.RIGHT:
            return this.right();
          case this.ACTIONS.UP:
            return this.up();
          case this.ACTIONS.DOWN:
            return this.down();
          case this.ACTIONS.OK:
            return this.confirm();
          case this.ACTIONS.CANCEL:
            return this.cancel();
          default:
            return null;
        }
      };

      GridController.prototype._getRowSize = function(event) {
        var movie, _i, _len, _ref;
        this.RowSize = 0;
        _ref = this.movies;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          movie = _ref[_i];
          if ($(movie).prev().length > 0 && $(movie).position().top !== $(movie).prev().position().top) {
            break;
          }
          this.RowSize++;
        }
        return this.LastRowSize = this.movies.length % this.RowSize === 0 ? this.RowSize : this.movies.length % this.RowSize;
      };

      GridController.prototype.left = function() {
        return this.gridMove(-1, 0);
      };

      GridController.prototype.up = function() {
        return this.gridMove(0, -1);
      };

      GridController.prototype.down = function() {
        return this.gridMove(0, 1);
      };

      GridController.prototype.right = function() {
        return this.gridMove(1, 0);
      };

      GridController.prototype.mouseMove = function(e) {
        setTimeout((function(_this) {
          return function() {
            var newListIndex, newMovie, newMovieIndex;
            newMovie = e.delegateTarget;
            if (!$(newMovie).hasClass(_this.HTML.movieClass.substr(1))) {
              return false;
            }
            newListIndex = $(newMovie).parents(_this.HTML.lists) ? Utils.getObjectKeyInArray(_this.lists, $(newMovie).parents(_this.HTML.lists)[0]) : _this.listIndex;
            _this._updateList(newListIndex);
            newMovieIndex = Utils.getObjectKeyInArray(_this.movies, newMovie);
            _this._updateMovie(newMovieIndex);
            return true;
          };
        })(this), 0);
        return true;
      };

      GridController.prototype.gridMove = function(x, y) {
        var axis, newMovieIndex;
        if (y === 0) {
          axis = 'horizontal';
          newMovieIndex = this.movieIndex + x;
        } else if (x === 0) {
          axis = 'vertical';
          newMovieIndex = this.movieIndex + (this.RowSize * y);
        }
        if (this.movies[newMovieIndex]) {
          return this._updateMovie(newMovieIndex);
        } else {
          if (this.movies.length - 1 < newMovieIndex && (this.lists[this.listIndex + 1] != null)) {
            newMovieIndex = this._nextList(axis);
          } else if (newMovieIndex < 0 && (this.lists[this.listIndex - 1] != null)) {
            newMovieIndex = this._prevList(axis);
          } else {
            return false;
          }
          this._updateMovie(newMovieIndex);
          return true;
        }
      };

      GridController.prototype._nextList = function(axis) {
        var newMovieIndex, _i, _ref, _ref1, _results;
        if (axis === 'horizontal') {
          newMovieIndex = 0;
          this._updateList(this.listIndex + 1);
        } else if (axis === 'vertical') {
          if (_ref = this.movieIndex, __indexOf.call((function() {
            _results = [];
            for (var _i = 0, _ref1 = this.movies.length - 1; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; 0 <= _ref1 ? _i++ : _i--){ _results.push(_i); }
            return _results;
          }).apply(this).slice(-this.LastRowSize), _ref) >= 0) {
            newMovieIndex = this.movieIndex % this.RowSize;
            this._updateList(this.listIndex + 1);
          } else {
            newMovieIndex = this.movies.length - 1;
          }
        }
        return newMovieIndex;
      };

      GridController.prototype._prevList = function(axis) {
        var newMovieIndex, _i, _ref, _results;
        this._updateList(this.listIndex - 1);
        if (axis === 'horizontal') {
          newMovieIndex = this.movies.length - 1;
        } else if (axis === 'vertical') {
          if (this.LastRowSize - 1 >= this.movieIndex) {
            newMovieIndex = (function() {
              _results = [];
              for (var _i = 0, _ref = this.movies.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
              return _results;
            }).apply(this).slice(-this.LastRowSize)[this.movieIndex];
          } else {
            newMovieIndex = this.movies.length - 1;
          }
        }
        return newMovieIndex;
      };

      GridController.prototype._updateList = function(newIndex) {
        var oldList;
        if (newIndex === this.listIndex || _.isEmpty(this.lists)) {
          return false;
        }
        oldList = this.List != null ? this.List.Object : null;
        this.listIndex = newIndex;
        this.List = new List(this.HTML, this.lists, this.listIndex);
        this.movies = this.List.Object.find(this.HTML.movies);
        this._getRowSize();
        return DomManipulation.toggleElement('list', this.List.Object, oldList);
      };

      GridController.prototype._updateMovie = function(newIndex) {
        var oldMovie;
        if (newIndex === this.movieIndex || _.isEmpty(this.movies)) {
          return false;
        }
        oldMovie = this.Movie != null ? this.Movie.Object : null;
        this.movieIndex = newIndex;
        this.Movie = new Movie(this.HTML, this.movies, this.movieIndex);
        return DomManipulation.toggleElement('movie', this.Movie.Object, oldMovie);
      };

      return GridController;

    })(BaseController);
  });

}).call(this);
