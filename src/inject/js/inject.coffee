# triggers when page is done loading
chrome.extension.sendMessage {}, (response) ->
    readyStateCheckInterval = setInterval () ->
        if document.readyState is "complete"
            clearInterval readyStateCheckInterval

            console.log "Hello. This message was sent from scripts/inject.jasds"
            # $('#global-header').append('<li><a id="sheboshebo1">Test1</a></li>')
            # $('#global-header').append('<li><a id="sheboshebo2">Test2</a></li>')

            # $('#sheboshebo1').hover(
            #     -> console.log('1 hover on!!!')
            #     -> console.log('1 hover off!!!')
            # )

            # $('#sheboshebo2').hover(
            #     -> console.log('2 hover on!!!')
            #     -> console.log('2 hover off!!!')
            # )

            # $('#sheboshebo1').click () ->
            #     console.log('1 click on!!!')
            # $('#sheboshebo2').click () ->
            #     console.log('2 clicked!!!')
            movie = $('.agMovie.agMovie-lulg').first().find("a")

            $(".gallery").bind "DOMNodeInserted", ->
                console.log "child is appended"








            # shebo1 = $('#sheboshebo1')
            # shebo2 = $('#sheboshebo2')

            # shebo1.simulate 'mouseover'
            # shebo2.simulate 'click'
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

getObjectKeyInArray = (array, object) ->
    for el, i in array
        if el is object
            return i
    false

isEmpty = (variable) ->
    not (variable?.length)

class EventHandler
    hhh = []
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
        console.log(action)
        KeyboardJS.on combo, (e) =>
            @dispatch(action)

class TransmissionHandler extends EventHandler

    constructor: ->
        @source = 'GroundControl'
        @target = 'MajorTom'

        window.addEventListener 'message', @_recieve
        # window.addEventListener 'message', (e) =>
        #     @_recieve(e)

    transmit: (action) =>
        # data = data || {}
        window.postMessage
            source: @source
            target: @target
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

    @nav = '.nav-wrap'
    @HTMLAndBody = 'html, body'

    @activeClass =
        list  : '.active-list'
        movie : '.active-movie'

class HomeSelectors extends HTMLSelectors

    @lists = 'div.mrow'

    @list =
        title         : 'div.hd h3' # text
        moviesWrapper : 'div.bd div.agMovieSet'

    @movies = 'div.bd div.agMovieSet div.agMovie'
    @movies = 'div.bd div.agMovie'
    @movieClass = '.agMovie'
    @movie =
        title  : 'span img' # alt property
        poster : 'span img' # src property
        url    : 'span a' # href property
        id     : 'span a' # data-uitrack, first part="70189472,13462929,35,0"

class GenreSelectors extends HTMLSelectors

    @lists = 'div#genrePage'

    @list =
        title         : 'div#genreControls a#title' # text
        moviesWrapper : 'div.gallery'

    @movies = 'div.gallery div.lockup'
    @movieClass = '.lockup'
    @movie =
        title  : 'img' # alt property
        poster : 'img' # src property
        url    : 'a' # href property
        id     : 'a' # data-uitrack, first part="70189472,13462929,35,0"

class DomManipulation

    @toggleElement: (type, newElement, oldElement) ->
        activeClass = HTMLSelectors.activeClass[type].substr 1
        # remove active mark from old movie
        if oldElement?
            oldElement.removeClass activeClass

        # add active mark from movie
        newElement.addClass activeClass

        if type is 'movie'
            @scrollToElement(newElement)

    @scrollToElementOLD: (element) ->
        HTML = HTMLSelectors

        offsetTop = (element.offset().top + element.height()) - $(window).scrollTop()
        offsetBottom = $(window).scrollTop() - (element.offset().top + element.height())

        ElementBottom = (element.offset().top - window.innerHeight) + element.height()
        ElementTop = element.offset().top - $(HTML.nav).height()

        if offsetTop > window.innerHeight or element.offset().top < $(window).scrollTop()
            $(HTML.HTMLAndBody).stop().animate
                scrollTop: ElementBottom
            , 300
        else if offsetBottom < 0
            $(HTML.HTMLAndBody).stop().animate
                scrollTop: ElementTop
            , 300

    @scrollToElement: (element) ->
        HTML = HTMLSelectors


        wHeight    = $(window).height() # height of the visiable window
        wScrollTop = $(window).scrollTop() # distance to top of the window
        eOffset    = element.offset().top # distance from the element to top of the window
        eHeight    = element.height() # height of the element
        nHeight    = $(HTML.nav).height() # height of the fixed navigation bar

        alignedToBottom = eOffset - wHeight + eHeight # bottom of the element in bottom of the screen
        alignedToTop    = eOffset - nHeight # top of the element in top of the screen

        if eOffset - wScrollTop + eHeight > wHeight # if the window height is smaller the distance
            scrollPosition = alignedToTop
        else if eOffset < wScrollTop
            scrollPosition = alignedToBottom

        $(HTML.HTMLAndBody).stop().animate
            scrollTop: scrollPosition
        , 300


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


class Movie

    constructor: (HTMLSelectors, movies, position = 0) ->
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
            setTimeout =>
                console.log "jquery event:", e
                @doAction(e.action)
            , 0

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

class GridController extends BaseController

    constructor: (HTMLSelectors) ->
        super
        @HTML = HTMLSelectors

        @lists = $ @HTML.lists

        @_updateList(0)
        @_updateMovie(0)

        $(window).resize @_getRowSize
        $(@HTML.movies).mouseover @_mouseMove

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
            if $(movie).prev().length > 0 and
            $(movie).position().top isnt $(movie).prev().position().top
                break
            @RowSize++

        @LastRowSize = if @movies.length % @RowSize is 0 then @RowSize else @movies.length % @RowSize

    left:  => @_gridMove(-1, 0)
    up:    => @_gridMove(0, -1)
    down:  => @_gridMove(0, 1)
    right: => @_gridMove(1, 0)

    _gridMove: (x, y) =>
        if y is 0
            axis = 'horizontal'
            newMovieIndex = @movieIndex+x
        if x is 0
            axis = 'vertical'
            newMovieIndex = @movieIndex+(@RowSize*y)

        # if new selected movie is with list boundries:
        if @movies[newMovieIndex] then @_updateMovie(newMovieIndex)
        else
            nextList = @lists[@listIndex+1]
            prevList = @lists[@listIndex-1]

            # when user moved right/down (next)
            if @movies.length-1 < newMovieIndex and nextList? # if no more movies and there's a next list
                newMovieIndex = @_nextList axis

            # when user moved left/up (previous)
            else if newMovieIndex < 0 and prevList? # if new movie is negative and there's a prev list
                newMovieIndex = @_prevList axis

            # when user went to next list but there's no next list OR vice versa
            else
                return false

            @_updateMovie(newMovieIndex)
            true

    _mouseMove: (e) =>
        setTimeout =>
            if not $(e.delegateTarget).hasClass @HTML.movieClass.substr(1)
                return false

            newListIndex = if $(e.delegateTarget).parents(@HTML.lists) then getObjectKeyInArray(@lists, $(e.delegateTarget).parents(@HTML.lists)[0]) else @listIndex
            newMovieIndex = getObjectKeyInArray(@movies, e.delegateTarget)

            @_updateList(newListIndex)
            @_updateMovie(newMovieIndex)

            return true
        , 0
        true

    _nextList: (axis) =>
        if axis is 'horizontal'
            newMovieIndex = 0 # first movie
            @_updateList(@listIndex+1)
        else if axis is 'vertical'
            if @movieIndex in [0..@movies.length-1][-@LastRowSize..] # if movie is part of last row
                newMovieIndex = @movieIndex % @RowSize # get movie location in last row
                @_updateList(@listIndex+1)
                newMovieIndex
            else
                newMovieIndex = @movies.length-1 # go to last movie in the current list
                newMovieIndex

    _prevList: (axis) =>
        @_updateList(@listIndex-1)
        if axis is 'horizontal'
            @movies.length-1 # last movie
        else if axis is 'vertical'
            if @LastRowSize-1 >= @movieIndex
                newMovieIndex = [0..@movies.length-1][-@LastRowSize..][@movieIndex]
                newMovieIndex
            else
                newMovieIndex = @movies.length-1 # last movie
                newMovieIndex

    _updateList : (newIndex) =>
        return if newIndex is @listIndex or isEmpty(@lists) then false

        oldList = if @List? then @List.Object else null
        # move marker to the new list
        @listIndex = newIndex
        # create the new list object
        @List = new List @HTML, @lists, @listIndex

        # fetch the movies of the new list
        @movies = @List.Object.find @HTML.movies
        # measure row size in new list
        @_getRowSize()

        # init related DOM manipulation
        DomManipulation.toggleElement('list', @List.Object, oldList)

    _updateMovie : (newIndex) =>
        return if newIndex is @movieIndex or isEmpty(@movies) then false

        oldMovie = if @Movie? then @Movie.Object else null
        # move marker to the new movie
        @movieIndex = newIndex
        # create the new movie object
        @Movie = new Movie @HTML, @movies, @movieIndex

        # init related DOM manipulation
        DomManipulation.toggleElement('movie', @Movie.Object, oldMovie)

class HomeController extends GridController

    constructor: ->
        @HTML = HomeSelectors
        super(@HTML)

class GenreController extends GridController

    constructor: ->
        @HTML = GenreSelectors
        super(@HTML)


ttt = new ActionHandler


if window.location.pathname.match "/WiHome"
    ttFt = new HomeController
else if window.location.pathname.match "/WiGenre"
    ttFt = new GenreController


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