# 'use strict'

define ['q', 'modules/handlers/event_handler', 'modules/utils'], (Q, EventHandler, Utils) ->
    # handling all transmissions between seperated scripts
    class TransmissionHandler extends EventHandler
        @source = 'Nebuchadnezzar'

        @_transmit: (recipient, type, data, uniqueId) =>
            console.log "#{@source}: Transmission is out", {recipient: recipient, type: type, data: data, uniqueId: uniqueId}
            window.postMessage
                uniqueId  : uniqueId
                sender    : @source
                recipient : recipient
                type      : type
                data      : data
                , '*'

        @_recieve: (event) =>
            if event.data.recipient is @source
                console.log "#{@source}: Transmission Recieved over", event
                @fire event.data

        @sendWait: (recipient, type, data=null, uniqueId=Utils.getUniqueId()) =>
            deferred = Q.defer()

            @_transmit recipient, type, data, uniqueId

            @on window, 'message', (event) =>
                if event.recipient is @source and event.uniqueId is uniqueId
                    @off window, 'message', arguments.callee
                    console.log "#{@source}: Transmission came back", event
                    deferred.resolve event

            deferred.promise

        @sendForget: (recipient, type, data=null, uniqueId=Utils.getUniqueId()) =>
            @_transmit recipient, type, data, uniqueId
            uniqueId

        window.addEventListener 'message', @_recieve