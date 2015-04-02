

# readyStateCheckInterval = setInterval () ->
#     if document.readyState is "complete"
#         clearInterval readyStateCheckInterval

class EventHandler

    constructor: ->
    dispatch: (action) =>
        $.event.trigger
            type: "NetflixHTPC"
            action: action
        false

class TransmissionHandler extends EventHandler
    source = 'MajorTom'
    target = 'GroundControl'
    constructor: ->
        window.addEventListener 'message', @_recieve
        # window.addEventListener 'message', (e) =>
        #     @_recieveMessage(e)

    transmit: (message, action) =>
        # action = action || {}
        window.postMessage
            source: @source
            action: action
            , '*'

    _recieve: (event) =>
        if event.data.source is @target
            console.log event
            @dispatch(event.data.action)

  # window.addEventListener("message", on_message);
  # on_message = (e) ->
  #   console.log e
  #   if e.origin == window.location.origin # only accept local messages
  #       console.log 'accept', e

# window.addEventListener 'c_message', (event) ->
#     if event.data.type == 'sync_get_response'
#         console.log event

jQuery(document).ready ($) ->

    # console.log netflix
    msg = new TransmissionHandler
    setTimeout ->
        # tell('test', {a:1,b:2})
        msg.transmit('test', {a:1,b:2})
        # window.postMessage { type: "sync_get", data: {'ddd': 'eee'} }, '*'

        # tell('myMsg', "The user is 'bob' and the password is 'secret'")
        # # postMessage("The user is 'bob' and the password is 'secret'", 'www.netflix.com')
        # # window.postMessage("The user is 'bob' and the password is 'secret'", 'www.netflix.com')

        # $.event.trigger
        #     type: "NetflixHTPC"
        #     action: 'right'
        # $(document).trigger
        #     type: "NetflixHTPC"
        #     action: 'down'
        # $(window).trigger
        #     type: "NetflixHTPC"
        #     action: 'left'
    , 5000


    # $(document).on netflix.sliders.htmlReadyEvent, (e) =>
    #     console.log "jquery event:", e
    # $(document).on netflix.GlobalHeader.hideMenuEvent, (e) =>
    #     console.log "GlobalHeader.hideMenuEvent event:", e
    # $(document).on netflix.GlobalEvents.resumeAnimationLoops, (e) =>
    #     console.log "GlobalEvents.resumeAnimationLoops event:", e