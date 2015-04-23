'use strict'

define ["modules/controllers/grid_controller", "modules/selectors/home_selectors"], (GridController, HomeSelectors) ->
    class HomeController extends GridController

        constructor: ->
            @HTML = HomeSelectors
            super(@HTML)