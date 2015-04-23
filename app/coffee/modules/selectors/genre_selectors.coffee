'use strict'

define ['modules/selectors/base_selectors'], (BaseSelectors) ->
    class GenreSelectors extends BaseSelectors

        @lists = 'div#genrePage'

        @list =
            title         : 'div#genreControls a#title' # text
            moviesWrapper : 'div.gallery'

        @movies = 'div.gallery div.lockup'
        @movieClass = '.lockup'
        @movie =
            title  : 'img' # alt property
            poster : 'img' # src property
            url    : 'a' # href property
            id     : 'a' # data-uitrack, first part="70189472,13462929,35,0"
