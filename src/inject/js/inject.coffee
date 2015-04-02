# triggers when page is done loading
chrome.extension.sendMessage {}, (response) ->
    readyStateCheckInterval = setInterval () ->
        if document.readyState is "complete"
            clearInterval readyStateCheckInterval

            console.log "Hello. This message was sent from scripts/inject.jasds"
            $('#global-header').append('<li><a id="sheboshebo1">Test1</a></li>')
            $('#global-header').append('<li><a id="sheboshebo2">Test2</a></li>')

            $('#sheboshebo1').hover(
                -> console.log('1 hover on!!!')
                -> console.log('1 hover off!!!')
            )

            $('#sheboshebo2').hover(
                -> console.log('2 hover on!!!')
                -> console.log('2 hover off!!!')
            )

            $('#sheboshebo1').click () ->
                console.log('1 click on!!!')
            $('#sheboshebo2').click () ->
                console.log('2 clicked!!!')


            movie = $('.agMovie.agMovie-lulg').first().find("a")
            shebo1 = $('#sheboshebo1')
            shebo2 = $('#sheboshebo2')

            shebo1.simulate 'mouseover'
            shebo2.simulate 'click'
            movie.simulate 'mouseover'

            anchor = movie.find("a") || movie
            anchor.simulate 'mouseover'


            # window.postMessage("The user is 'bob' and the password is 'secret'", 'http://www.netflix.com')


            # args = {}
            # args.filter = "NetflixControl"
            # args.event = 'MSG!!!'
            # window.postMessage args, "*"



            # simulate elem.get(0), "mouseover"
            # $.simulate movie, "mouseover"


        return
    , 10
    return

class EventHandler

    constructor: ->
    dispatch: (action) =>
        $.event.trigger
            type: "NetflixHTPC"
            action: action
        false

class ActionHandler extends EventHandler

    @actions = [
        'left', 'up', 'right', 'down'
        'ok', 'cancel'
    ]

    constructor: ->
        super
        @initShortcuts()

    initShortcuts: =>
        chrome.storage.sync.get @actions, (shortcuts) =>
            for action, combo of shortcuts
                @bindShortcuts(action, combo)

    # this method exist only because Keyboard.JS bug
    # every action in the callback that under a loop - get's overriden by the last action
    bindShortcuts: (action, combo) =>
        KeyboardJS.on combo, (e) =>
            @dispatch(action)

class TransmissionHandler extends EventHandler
    source = 'GroundControl'
    target = 'MajorTom'

    constructor: ->
        window.addEventListener 'message', @_recieve
        # window.addEventListener 'message', (e) =>
        #     @_recieve(e)

    transmit: (action) =>
        # data = data || {}
        window.postMessage
            source: @source
            action: action
            , '*'

    _recieve: (event) =>
        if event.data.source is @target
            console.log event
            @dispatch(event.data.action)

            # $.event.trigger
            #     type: "NetflixHTPC"
            #     action: action
            # @transmit('test-back', {a:3,b:4})


class HTMLSelectors

    @toHide = ['']
    @toDelete = [
        '.sliderButton'
        '.boxShotDivider' # horizontal lines that start/end movie lists
        '.recentlyWatched .cta-recommend' # recomend button inside recentlyWatched (first) movie
    ]

    @lists = 'div.mrow'

    @list =
        title         : 'div.hd h3' # text
        moviesWrapper : 'div.bd div.agMovieSet'

    @movies = 'div.bd div.agMovieSet div.agMovie'
    @movie =
        title  : 'span img' # alt property
        poster : 'span img' # src property
        url    : 'span a' # href property
        id     : 'span a' # data-uitrack, first part="70189472,13462929,35,0"

class List

    constructor: (lists, position = 0) ->
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


class Movie

    constructor: (movies, position = 0) ->
        @HTML = HTMLSelectors

        @Object   = @_getObject(movies, position)
        @Title    = @_getTitle()
        @Poster   = @_getPoster()
        @URL      = @_getURL()

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




class BaseController

    constructor: ->
        @ACTIONS =
            LEFT   : 'left'
            RIGHT  : 'right'
            UP     : 'up'
            DOWN   : 'down'
            OK     : 'ok'
            CANCEL : 'cancel'

        $(document).on "NetflixHTPC", (e) =>
            console.log "jquery event:", e
            @doAction(e.action)

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

class HomeController extends BaseController

    constructor: ->
        super
        @HTML = HTMLSelectors

        $(window).resize @_getRowSize

        @lists = $ @HTML.lists
        @listIndex = 0
        @List = new List @lists, @listIndex

        @movies = @List.Object.find @HTML.movies
        @movieIndex = 0
        @Movie = new Movie @movies, @movieIndex

    doAction: (action) =>
        switch action
            when @ACTIONS.LEFT   then @left()
            when @ACTIONS.RIGHT  then @right()
            when @ACTIONS.UP     then @up()
            when @ACTIONS.DOWN   then @down()
            when @ACTIONS.OK     then @confirm()
            when @ACTIONS.CANCEL then @cancel()

    _getRowSize: (event) =>
        @RowSize = 0
        for movie in @movies
            if movie.prev().length > 0 and
            $(this).position().top isnt $(this).prev().position().top
                break
            lisInRow++

        @LastRowSize = if @movies.length % lisInRow is 0 then lisInRow else @movies.length % lisInRow

    left:  => @_move(-1, 0)
    up:    => @_move(0, -1)
    down:  => @_move(0, 1)
    right: => @_move(1, 0)

    _move: (x, y) =>
        if y is 0
            # newIndex = if @movies.length-1 > @movieIndex+x then @movieIndex+x else @movieIndex
            @navigateToMovie(@movieIndex+x)
        if x is 0
            @navigateToMovie(@movieIndex+@RowSize)

    navigateToList: (newIndex) =>
        if @lists.length-1 < newIndex
            false

        @List.Object.removeClass 'active-list'

        @listIndex = newIndex
        @List = new List @lists, @listIndex

        @List.Object.addClass 'active-list'

        @navigateToMovie 0

    navigateToMovie: (newIndex) =>
        if @movies.length-1 < newIndex
            @navigateToList @listIndex+1
            false
        @Movie.Object.removeClass 'active-movie'

        @movieIndex = newIndex
        @Movie = new List @movies, @movieIndex
        @Movie.Object.addClass 'active-movie'






ttt = new ActionHandler
ttFt = new HomeController
# console.log KeyboardJS.key.name(39)


script = document.createElement("script")
script.src = chrome.extension.getURL "js/jquery/jquery.min.js"
document.head.appendChild(script)

script = document.createElement("script")
script.src = chrome.extension.getURL "src/inject/js/controller.js"
document.head.appendChild(script)


window.addEventListener 'message',  (event) ->
    if event.data.type == 'sync_get'
        console.log event
        window.postMessage({ type: "sync_get_response", items: 'items' }, '*')


msg = new TransmissionHandler

# window.addEventListener("message", receiveMessage, false);
# window.addEventListener("message", receiveMessage1);
# window.addEventListener("myMsg", receiveMessage2);

# receiveMessage = (event) ->
#     console.log 'msg: ', event

# receiveMessage1 = (event) ->
#     console.log 'msg1: ', event

# receiveMessage2 = (event) ->
#     console.log 'msg2: ', event

# chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
#     console.log 'chrome.runtime.onMessage', message, sender, sendResponse

# window.postMessage("The user is 'bob' and the password is 'secret'", 'http://www.netflix.com')


# args = {}
# args.filter = "NetflixControl"
# args.event = 'MSG!!!'
# window.postMessage args, "*"

# window.addEventListener("message", on_message, false)
# window.addEventListener("FROM_PAGE", on_message, false)

# on_message = (e) ->
#     console.log e
#     if e.origin == window.location.origin # only accept local messages
#         console.log 'accept', e