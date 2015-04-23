'use strict'

define ["modules/controllers/grid_controller", "modules/selectors/genre_selectors"], (GridController, GenreSelectors) ->
    class GenreController extends GridController

        constructor: ->
            @HTML = GenreSelectors
            super(@HTML)