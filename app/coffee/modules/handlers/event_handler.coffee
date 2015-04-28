'use strict'

define [], () ->
    class EventHandler

        @fire: (type, msg) =>
            evt = new CustomEvent type, { detail: msg }
            document.dispatchEvent evt
            false

        @on  : (type, callback) ->
            document.addEventListener type, (e) ->
                eventData = if e.detail then e.detail else e.data
                callback eventData
            return
        @off : (type, callback) ->
            document.removeEventListener type, callback
            return
        @one : (type, callback) =>
            @on type, (e) =>
                @off type, callback
                callback e
            return
