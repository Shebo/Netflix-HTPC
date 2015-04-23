(function() {
  'use strict';
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['modules/selectors/base_selectors'], function(BaseSelectors) {
    var GenreSelectors;
    return GenreSelectors = (function(_super) {
      __extends(GenreSelectors, _super);

      function GenreSelectors() {
        return GenreSelectors.__super__.constructor.apply(this, arguments);
      }

      GenreSelectors.lists = 'div#genrePage';

      GenreSelectors.list = {
        title: 'div#genreControls a#title',
        moviesWrapper: 'div.gallery'
      };

      GenreSelectors.movies = 'div.gallery div.lockup';

      GenreSelectors.movieClass = '.lockup';

      GenreSelectors.movie = {
        title: 'img',
        poster: 'img',
        url: 'a',
        id: 'a'
      };

      return GenreSelectors;

    })(BaseSelectors);
  });

}).call(this);
