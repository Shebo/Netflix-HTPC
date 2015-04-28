'use strict'

define ["jquery", 'modules/handlers/event_handler'], ($, EventHandler) ->

    # abstract class for navigation
    class BaseController

        constructor: ->
            @ACTIONS =
                LEFT   : 'left'
                RIGHT  : 'right'
                UP     : 'up'
                DOWN   : 'down'
                OK     : 'ok'
                CANCEL : 'cancel'

            # $(document).on "OSN:Controls", (e) =>
            EventHandler.on "OSN:Controls", (e) =>
                # setTimeout =>
                console.log "jquery event:", e
                @doAction(e.action)
                # , 0

        doAction: (action) =>
            console.log "Do #{action}"
        up: =>
            console.log "up"
        down: =>
            console.log "down"
        right: =>
            console.log "right"
        left: =>
            console.log "left"
        enter: =>
            console.log "enter"
        cancel: =>
            console.log "cancel"
            # if window.history.length <= 1
            #     chrome.runtime.sendMessage 'closetab'
            # else
            #     window.history.go -1
