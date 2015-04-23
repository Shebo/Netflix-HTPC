(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(["modules/selectors/base_selectors"], function(BaseSelectors) {
    var HomeSelectors;
    return HomeSelectors = (function(_super) {
      __extends(HomeSelectors, _super);

      function HomeSelectors() {
        return HomeSelectors.__super__.constructor.apply(this, arguments);
      }

      HomeSelectors.lists = 'div.mrow';

      HomeSelectors.list = {
        title: 'div.hd h3',
        moviesWrapper: 'div.bd div.agMovieSet'
      };

      HomeSelectors.movies = 'div.bd div.agMovieSet div.agMovie';

      HomeSelectors.movies = 'div.bd div.agMovie';

      HomeSelectors.movieClass = '.agMovie';

      HomeSelectors.movie = {
        title: 'span img',
        poster: 'span img',
        url: 'span a',
        id: 'span a'
      };

      return HomeSelectors;

    })(BaseSelectors);
  });

}).call(this);
