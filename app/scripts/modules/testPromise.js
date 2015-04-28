(function() {
  'use strict';
  define(['require', "q", "underscore"], function(require, Q, _) {
    var deferred;
    deferred = Q.defer();
    setTimeout(function() {
      console.log('yellow');
      return deferred.resolve('yellss211s22ow');
    }, 5000);
    return deferred.promise;
  });

}).call(this);
