'use strict'

define ['jquery'], ($) ->

   # Netflix Movie object
    class Movie

        constructor: (HTMLSelectors, movies, position = 0) ->
            @HTML = HTMLSelectors

            @Object     = @_getObject(movies, position)
            @Title      = @_getTitle()
            @Poster     = @_getPoster()
            @URL        = @_getURL()
            @MovieID    = @_getMovieID()
            @TrackID    = @_getTrackID()
            @ListIndex  = @_getListIndex()
            @MovieIndex = @_getMovieIndex()

        _getObject: (collection, position) ->
            if position == 0
                collection.first()
            else if position == collection.length-1
                collection.last()
            else
                collection.eq position

        _getTitle: ->
            @Object.find(@HTML.movie.title).attr('alt')
        _getPoster: ->
            @Object.find(@HTML.movie.poster).attr('src')
        _getURL: ->
            @Object.find(@HTML.movie.url).attr('href')
        _getMovieID: ->
            @Object.find(@HTML.movie.url).attr('data-uitrack').split(',')[0]
        _getTrackID: ->
            @Object.find(@HTML.movie.url).attr('data-uitrack').split(',')[1]
        _getListIndex: ->
            @Object.find(@HTML.movie.url).attr('data-uitrack').split(',')[2]
        _getMovieIndex: ->
            @Object.find(@HTML.movie.url).attr('data-uitrack').split(',')[3]
