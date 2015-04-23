(function() {
  'use strict';
  define(["jquery", 'modules/selectors/base_selectors'], function($, BaseSelectors) {
    var DomManipulation;
    return DomManipulation = (function() {
      function DomManipulation() {}

      DomManipulation.toggleElement = function(type, newElement, oldElement) {
        var activeClass;
        activeClass = BaseSelectors.activeClass[type].substr(1);
        if (oldElement != null) {
          oldElement.removeClass(activeClass);
        }
        newElement.addClass(activeClass);
        if (type === 'movie') {
          return this.scrollToElement(newElement);
        }
      };

      DomManipulation.scrollToElement = function(element) {
        var HTML, alignedToBottom, alignedToTop, eHeight, eOffset, nHeight, scrollPosition, wHeight, wScrollTop;
        HTML = BaseSelectors;
        wHeight = $(window).height();
        wScrollTop = $(window).scrollTop();
        eOffset = element.offset().top;
        eHeight = element.height();
        nHeight = $(HTML.nav).height();
        alignedToBottom = eOffset - wHeight + eHeight;
        alignedToTop = eOffset - nHeight;
        if (eOffset - wScrollTop + eHeight > wHeight) {
          scrollPosition = alignedToTop;
        } else if (eOffset < wScrollTop) {
          scrollPosition = alignedToBottom;
        }
        return $(HTML.HTMLAndBody).stop().animate({
          scrollTop: scrollPosition
        }, 300);
      };

      return DomManipulation;

    })();
  });

}).call(this);
