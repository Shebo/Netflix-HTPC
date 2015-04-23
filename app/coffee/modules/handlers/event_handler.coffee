'use strict'

define ["jquery"], ($) ->
    class EventHandler
        constructor: ->
        dispatch: (type, action, info = undefined) =>
            # safe dispatch - dispatch event only after jQuery ($ object) is loaded
            if $? then @_safeDispatch type, action, info
            else
                dispatchInterval = setInterval () ->
                    if $?
                        clearInterval dispatchInterval
                        @_safeDispatch type, action, info
                , 10

        _safeDispatch: (type, action, info) =>
            $.event.trigger
                type   : type
                action : action
                info   : info
            false
