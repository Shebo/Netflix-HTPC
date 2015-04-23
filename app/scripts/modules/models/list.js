(function() {
  'use strict';
  define(['jquery'], function($) {
    var List;
    return List = (function() {
      function List(HTMLSelectors, lists, position) {
        if (position == null) {
          position = 0;
        }
        this.HTML = HTMLSelectors;
        this.Object = this._getObject(lists, position);
        this.Title = this._getTitle();
      }

      List.prototype._getObject = function(collection, position) {
        if (position === 0) {
          return collection.first();
        } else if (position === collection.length - 1) {
          return collection.last();
        } else {
          return collection.eq(position);
        }
      };

      List.prototype._getTitle = function() {
        return $.trim(this.Object.find(this.HTML.list.title).last().text());
      };

      return List;

    })();
  });

}).call(this);
