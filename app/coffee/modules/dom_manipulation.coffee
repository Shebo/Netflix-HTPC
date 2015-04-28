'use strict'

define ["jquery", 'modules/selectors/base_selectors'], ($, BaseSelectors) ->
    class DomManipulation

        @toggleElement: (type, newElement, oldElement) ->
            activeClass = BaseSelectors.activeClass[type].substr 1
            # remove active mark from old movie
            if oldElement?
                oldElement.removeClass activeClass

            # add active mark from movie
            newElement.addClass activeClass

            if type is 'movie'
                @scrollToElement(newElement)

        @scrollToElement: (element) ->
            HTML = BaseSelectors


            wHeight    = $(window).height() # height of the visiable window
            wScrollTop = $(window).scrollTop() # distance to top of the window
            eOffset    = element.offset().top # distance from the element to top of the window
            eHeight    = element.height() # height of the element
            nHeight    = $(HTML.nav).height() # height of the fixed navigation bar

            alignedToBottom = eOffset - wHeight + eHeight # bottom of the element in bottom of the screen
            alignedToTop    = eOffset - nHeight # top of the element in top of the screen

            if eOffset - wScrollTop + eHeight > wHeight # if the window height is smaller the distance
                scrollPosition = alignedToTop
            else if eOffset < wScrollTop
                scrollPosition = alignedToBottom

            $(HTML.HTMLAndBody).stop().animate
                scrollTop: scrollPosition
            , 300
