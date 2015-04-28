'use strict'

define ["modules/selectors/base_selectors"], (BaseSelectors) ->
    class HomeSelectors extends BaseSelectors

        @lists = 'div.mrow'

        @list =
            title         : 'div.hd h3' # text
            moviesWrapper : 'div.bd div.agMovieSet'

        @movies = 'div.bd div.agMovieSet div.agMovie'
        @movies = 'div.bd div.agMovie'
        @movieClass = '.agMovie'
        @movie =
            title  : 'span img' # alt property
            poster : 'span img' # src property
            url    : 'span a' # href property
            id     : 'span a' # data-uitrack, first part="70189472,13462929,35,0"

