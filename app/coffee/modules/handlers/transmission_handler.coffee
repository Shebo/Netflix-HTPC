'use strict'

define ['modules/handlers/event_handler'], (EventHandler) ->
    # handling all transmissions between seperated scripts
    class TransmissionHandler extends EventHandler

        constructor: (source) ->
            # @source = 'GroundControl'
            @source = source

            window.addEventListener 'message', @_recieve
            # window.addEventListener 'message', (e) =>
            #     @_recieve(e)

        transmit: (target, type, action, data = undefined) =>
            # data = data || {}
            window.postMessage
                sender    : @source
                recipient : target
                action    : action
                type      : type
                data      : data
                , '*'

        _recieve: (event) =>
            msg = event.data
            @dispatch msg.type, msg.action, msg.data if msg.recipient is @source

                # if msg.type is 'request'
                #     @transmit msg.from, 'response', @[msg.action]()
                # else if msg.type is 'response'
                #     console.log 'response'
                # else if msg.type is 'OSN:Constants'
                #     @dispatch(msg.type, 'update', msg.data)
