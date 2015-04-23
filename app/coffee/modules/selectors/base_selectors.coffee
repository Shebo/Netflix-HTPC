'use strict'

define [], () ->

   class BaseSelectors
        # elements needs to be hidden
        @toHide = ['']

        # elements needs to remove
        @toDelete = [
            '.sliderButton'
            '.boxShotDivider' # horizontal lines that start/end movie lists
            '.recentlyWatched .cta-recommend' # recomend button inside recentlyWatched (first) movie
        ]

        @HTMLAndBody = 'html, body'
        @nav = '.nav-wrap'

        @activeClass =
            list  : '.active-list'
            movie : '.active-movie'
