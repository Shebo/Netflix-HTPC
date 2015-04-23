(function() {
  'use strict';
  define(['jquery'], function($) {
    var Movie;
    return Movie = (function() {
      function Movie(HTMLSelectors, movies, position) {
        if (position == null) {
          position = 0;
        }
        this.HTML = HTMLSelectors;
        this.Object = this._getObject(movies, position);
        this.Title = this._getTitle();
        this.Poster = this._getPoster();
        this.URL = this._getURL();
        this.MovieID = this._getMovieID();
        this.TrackID = this._getTrackID();
        this.ListIndex = this._getListIndex();
        this.MovieIndex = this._getMovieIndex();
      }

      Movie.prototype._getObject = function(collection, position) {
        if (position === 0) {
          return collection.first();
        } else if (position === collection.length - 1) {
          return collection.last();
        } else {
          return collection.eq(position);
        }
      };

      Movie.prototype._getTitle = function() {
        return this.Object.find(this.HTML.movie.title).attr('alt');
      };

      Movie.prototype._getPoster = function() {
        return this.Object.find(this.HTML.movie.poster).attr('src');
      };

      Movie.prototype._getURL = function() {
        return this.Object.find(this.HTML.movie.url).attr('href');
      };

      Movie.prototype._getMovieID = function() {
        return this.Object.find(this.HTML.movie.url).attr('data-uitrack').split(',')[0];
      };

      Movie.prototype._getTrackID = function() {
        return this.Object.find(this.HTML.movie.url).attr('data-uitrack').split(',')[1];
      };

      Movie.prototype._getListIndex = function() {
        return this.Object.find(this.HTML.movie.url).attr('data-uitrack').split(',')[2];
      };

      Movie.prototype._getMovieIndex = function() {
        return this.Object.find(this.HTML.movie.url).attr('data-uitrack').split(',')[3];
      };

      return Movie;

    })();
  });

}).call(this);
