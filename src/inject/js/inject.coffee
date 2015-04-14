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

            # $.ajax url: 'http://www.netflix.com/WiGenre?agid=7627', dataType: 'html', success: (result) ->

            #     serverDefs = /"serverDefs":{"data":({.*?}),"/gi
            #     object = serverDefs.exec result
            #     console.log 'inject', object[1]
            #     JSON.parse object[1]


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

class Utils

    @getObjectKeyInArray: (array, object) ->
        for el, i in array
            if el is object
                return i
        false

    @isJson: (str) ->
        try
            JSON.parse str
        catch e
            return false
        true

    @injectScript: (path) ->
        script = document.createElement "script"
        script.src = chrome.extension.getURL path
        document.head.appendChild script

    @rawAjax: (url) ->
        request = new XMLHttpRequest()
        deferred = Q.defer()
        request.open 'GET', url, true

        request.onload = ->
            if request.status is 200
                result = if Utils.isJson request.responseText then JSON.parse request.responseText else request.responseText
                deferred.resolve result
            else
                deferred.reject request.status

        request.onerror = ->
            deferred.reject request.status

        request.onprogress = ->
            deferred.notify event.loaded / event.total

        request.send()
        deferred.promise;

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


# handling all keyboard actions
class ActionHandler extends EventHandler

    constructor: ->
        super
        @actions = [
            'left', 'up', 'right', 'down'
            'ok', 'cancel'
        ]
        @_initShortcuts()
        @_initActionBlocker()

    # get all user's registerd action combos and bind them
    _initShortcuts: =>
        chrome.storage.sync.get @actions, (shortcuts) =>
            for action, combo of shortcuts
                @_bindShortcuts action, combo
            true

    _initActionBlocker: =>
        @isAllowed = true
        # deny action if in input/textarea/utton element is focused on
        $(":input").focus (e) => @isAllowed = false
        # re-allow action if in input/textarea/utton element is focused out
        $(":input").blur (e) => @isAllowed = true

    # this method exist only because Keyboard.JS bug
    # every action in the callback that under a loop - get's overriden by the last action
    _bindShortcuts: (action, combo) =>
        KeyboardJS.on combo, (e) =>
            @dispatch 'OSN:Controls', action if @isAllowed

# handling all transmissions between seperated scripts
class TransmissionHandler extends EventHandler

    constructor: ->
        @source = 'GroundControl'

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


class Constants

    constructor: ->
        # chrome.storage.local.clear () =>
        @getNetflixData().then (data) =>
            @data = true
            console.log 'yes consts'
            @saveNetflixData(data)
        , (error) =>
            console.log 'no consts'
            @data = false

        $(document).on "OSN:Constants", (e) =>
            if e.action is 'update'
                @setNetflixData JSON.stringify(e.info), () => @saveNetflixData JSON.stringify(e.info)

    getNetflixData: =>
        deferred = Q.defer()

        chrome.storage.local.get 'netflixData', (data) =>
            if not _.isEmpty data
                @saveNetflixData data['netflixData']
                deferred.resolve data['netflixData']
            else
                deferred.reject()

        deferred.promise

    setNetflixData: (data, callback) =>
        chrome.storage.local.set {netflixData: data}, callback

    saveNetflixData: (data) =>
        @[k] = v for k, v of JSON.parse data


class NetflixAPI
    @isRelative = true

    @_getRoot: =>
        if not @isRelative then "#{if constants.isSecure then "https" else "http"}://#{constants.domain}/" else ''

    @_getAPIRoot: =>
        "#{@_getRoot()}/#{constants.APIRoot}/#{constants.APIKey}"

    @getMovieInfo: (movieID, trackID, jquery=true, style='shakti') ->

        if jquery
            Q $.getJSON "#{@_getRoot()}/#{constants.APIRoot}/#{constants.APIKey}/bob",
                titleid: movieID
                trackid: trackID
                authURL: constants.authURL
        else
            Utils.rawAjax "#{@_getRoot()}/#{constants.APIRoot}/#{constants.APIKey}/bob?titleid=#{movieID}&trackid=#{trackID}&authURL=#{constants.authURL}"


class HTMLSelectors
    # elements needs to be hidden
    @toHide = ['']

    # elements needs to remove
    @toDelete = [
        '.sliderButton'
        '.boxShotDivider' # horizontal lines that start/end movie lists
        '.recentlyWatched .cta-recommend' # recomend button inside recentlyWatched (first) movie
    ]

    @HTMLAndBody = 'html, body'
    @nav = '.nav-wrap'

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

        $(document).on "OSN:Controls", (e) =>
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


# Manages navigation on grid-like pages
class GridController extends BaseController

    constructor: (HTMLSelectors) ->
        super
        @HTML = HTMLSelectors

        @lists = $ @HTML.lists

        # setting first list and movie
        @_updateList 0
        @_updateMovie 0

        # register resize to row measurement
        $(window).resize @_getRowSize
        # bind mouse hover to movie navigation
        $(@HTML.movies).mouseover @_mouseMove

    doAction: (action) =>
        switch action
            when @ACTIONS.LEFT   then @left()
            when @ACTIONS.RIGHT  then @right()
            when @ACTIONS.UP     then @up()
            when @ACTIONS.DOWN   then @down()
            when @ACTIONS.OK     then @confirm()
            when @ACTIONS.CANCEL then @cancel()
            else null

    # measuring how many movies in a row, and how much is in last row
    _getRowSize: (event) =>
        @RowSize = 0
        for movie in @movies
            if $(movie).prev().length > 0 and
            $(movie).position().top isnt $(movie).prev().position().top
                break
            @RowSize++

        @LastRowSize = if @movies.length % @RowSize is 0 then @RowSize else @movies.length % @RowSize

    #
    left  : => @_gridMove -1,  0
    up    : => @_gridMove  0, -1
    down  : => @_gridMove  0,  1
    right : => @_gridMove  1,  0

    # navigate to hoverd list and movie, running over previous list/movie
    _mouseMove: (e) =>
        setTimeout =>
            newMovie = e.delegateTarget
            # if hovering already active movie
            return false if not $(newMovie).hasClass @HTML.movieClass.substr 1

            # get the index of the selected movie
            newListIndex  = if $(newMovie).parents(@HTML.lists) then Utils.getObjectKeyInArray @lists, $(newMovie).parents(@HTML.lists)[0]  else @listIndex
            @_updateList newListIndex

            # get the index of the selected movie
            newMovieIndex = Utils.getObjectKeyInArray @movies, newMovie
            @_updateMovie newMovieIndex

            true
        , 0
        true

    # navigating on lists/movies grid, one movie at-the-time
    # calculating if next movie is in a current/previous/next list
    _gridMove: (x, y) =>

        # if user movement was vertical or horizontal
        if y is 0
            axis = 'horizontal'
            newMovieIndex = @movieIndex+x
        else if x is 0
            axis = 'vertical'
            newMovieIndex = @movieIndex+(@RowSize*y)

        # if new selected movie is with list boundries:
        if @movies[newMovieIndex] then @_updateMovie newMovieIndex
        else

            # when user moved right/down (next)
            if @movies.length-1 < newMovieIndex and @lists[@listIndex+1]? # if no more movies and there's a next list
                newMovieIndex = @_nextList axis

            # when user moved left/up (previous)
            else if newMovieIndex < 0 and @lists[@listIndex-1]? # if new movie is negative and there's a prev list
                newMovieIndex = @_prevList axis

            # when user went to next list but there's no next list OR vice versa
            else return false

            @_updateMovie newMovieIndex
            true

    # updating to next list if needed
    # calculating the new movie index and returning it
    _nextList: (axis) =>
        if axis is 'horizontal'
            newMovieIndex = 0 # first movie
            @_updateList @listIndex+1
        else if axis is 'vertical'
            if @movieIndex in [0..@movies.length-1][-@LastRowSize..] # if movie is part of last row
                newMovieIndex = @movieIndex % @RowSize # get movie location in last row
                @_updateList @listIndex+1
            else
                newMovieIndex = @movies.length-1 # go to last movie in the current list
        newMovieIndex

    # updating to prev list
    # calculating the new movie index and returning it
    _prevList: (axis) =>
        @_updateList @listIndex-1
        if axis is 'horizontal'
            newMovieIndex = @movies.length-1 # last movie
        else if axis is 'vertical'
            if @LastRowSize-1 >= @movieIndex
                newMovieIndex = [0..@movies.length-1][-@LastRowSize..][@movieIndex] # prev row in the same movie-in-a-row position as the current movie
            else
                newMovieIndex = @movies.length-1 # last movie
        newMovieIndex

    # updating list object, index and the movies array
    _updateList : (newIndex) =>
        return if newIndex is @listIndex or _.isEmpty @lists then false

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
        DomManipulation.toggleElement 'list', @List.Object, oldList

    # updating movie object, index
    _updateMovie : (newIndex) =>
        return if newIndex is @movieIndex or _.isEmpty @movies then false

        oldMovie = if @Movie? then @Movie.Object else null
        # move marker to the new movie
        @movieIndex = newIndex
        # create the new movie object
        @Movie = new Movie @HTML, @movies, @movieIndex

        # init related DOM manipulation
        DomManipulation.toggleElement 'movie', @Movie.Object, oldMovie

class HomeController extends GridController

    constructor: ->
        @HTML = HomeSelectors
        super(@HTML)

class GenreController extends GridController

    constructor: ->
        @HTML = GenreSelectors
        super(@HTML)


constants = new Constants



init = () ->

    # start listening to transmitions
    msg = new TransmissionHandler

    # Infiltrating to netflix.com...
    Utils.injectScript "js/jquery/jquery.min.js"
    Utils.injectScript "src/inject/js/controller.js"

    #
    actionHandler = new ActionHandler
    if window.location.pathname.match "/WiHome"
        controller = new HomeController
    else if window.location.pathname.match "/WiGenre"
        controller = new GenreController

    testAPI = (movieID, trackID) ->
        deferred = Q.defer()

        constants.getNetflixData().then (data) ->
            deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false
        , (error) ->
            deferred.reject 0

        # if typeof constants.data is 'boolean' and not constants.data
        #     deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false
        # else
        #     loadedConstantsInterval = setInterval () ->
        #         if typeof constants.data is 'boolean'
        #             clearInterval loadedConstantsInterval
        #             deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false if not constants.data
        #     , 10

        deferred.promise

    testAPI('70180183', '13462047').fail (error) ->
        if error is 404 or # APIKey isn't updated
        error is 0 # Data is empty
            msg.transmit 'MajorTom', 'OSN:Constants', 'fetch'

init()








# window.addEventListener 'message',  (event) ->
#     if event.data.type == 'sync_get'
#         console.log event
#         window.postMessage({ type: "sync_get_response", items: 'items' }, '*')




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