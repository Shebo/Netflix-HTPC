'use strict'

define ['jquery'], ($) ->

   # Netflix List object
    class List

        constructor: (HTMLSelectors, lists, position = 0) ->
            @HTML = HTMLSelectors

            @Object = @_getObject(lists, position)
            @Title = @_getTitle()

        _getObject: (collection, position) ->
            if position == 0
                collection.first()
            else if position == collection.length-1
                collection.last()
            else
                collection.eq position

        _getTitle: ->
            $.trim @Object.find(@HTML.list.title).last().text()
