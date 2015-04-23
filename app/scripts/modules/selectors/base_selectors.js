(function() {
  'use strict';
  define([], function() {
    var BaseSelectors;
    return BaseSelectors = (function() {
      function BaseSelectors() {}

      BaseSelectors.toHide = [''];

      BaseSelectors.toDelete = ['.sliderButton', '.boxShotDivider', '.recentlyWatched .cta-recommend'];

      BaseSelectors.HTMLAndBody = 'html, body';

      BaseSelectors.nav = '.nav-wrap';

      BaseSelectors.activeClass = {
        list: '.active-list',
        movie: '.active-movie'
      };

      return BaseSelectors;

    })();
  });

}).call(this);
