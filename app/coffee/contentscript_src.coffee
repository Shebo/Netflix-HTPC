'use strict'

# console.log(require.toUrl())
# require ['jquery', 'keyboard', 'require'], ($, keyboard, require) ->
#   # inject css
#   # $('body').css 'background', 'red'
#   console.log 'mememessesd'

require.config({
  # waitSeconds: 20,
  baseUrl: chrome.extension.getURL('scripts'),
  waitSeconds: 60,
  shim: {
    simulate   : 'jquery',
    bootstrap  : 'jquery'
  },
  paths: {
    # almond     : '../bower_components/almond/almond',
    # text       : '../bower_components/requirejs-plugins/lib/text',
    # async      : '../bower_components/requirejs-plugins/src/async',
    # json       : '../bower_components/requirejs-plugins/src/json',
    promise    : '../bower_components/requirejs-promise/requirejs-promise',
    # promiseme  : '../bower_components/requirejs-promiseme/promiseme',
    # rq         : '../bower_components/requirejs-q/require-q',
    jquery     : '../bower_components/jquery/dist/jquery',
    q          : '../bower_components/q/q',
    watch      : '../bower_components/watch/src/watch',
    simulate   : '../bower_components/jquery-simulate/jquery-simulate',
    underscore : '../bower_components/underscore/underscore',
    bootstrap  : '../bower_components/bootstrap/dist/js/bootstrap',
    KeyboardJS : '../bower_components/KeyboardJS/keyboard',
    gamepad    : '../bower_components/HTML5-JavaScript-Gamepad-Controller-Library/gamepad'
    # jsonp: '../bower_components/jsonp/jsonp',

    # leaflet: '../bower_components/leaflet/dist/leaflet',
    # mediaelement: '../bower_components/mediaelement/build/mediaelement',
    # moment: '../bower_components/momentjs/moment'
  },
  packages: [

  ]
});


require [
	'q',
	# 'promise!modules/config',
	'modules/netflix_api',
	'modules/utils',
	'modules/handlers/action_handler',
	'modules/handlers/transmission_handler',
	'modules/controllers/home_controller',
	'modules/controllers/genre_controller',
], (Q, NetflixAPI, Utils, ActionHandler, TransmissionHandler, HomeController, GenreController) ->
    # console.log 'Config1', Config
    # Config.set('sync', 'test', 88).then () -> console.log 'Config2', Config.get()

    # start listening to transmitions
    # msg = new TransmissionHandler('GroundControl')

    console.log 'Config2222'
    #
    # actionHandler = new ActionHandler
    if window.location.pathname.match "/WiHome"
        controller = new HomeController
    else if window.location.pathname.match "/WiGenre"
        controller = new GenreController

# triggers when page is done loading
chrome.extension.sendMessage {}, (response) ->
    readyStateCheckInterval = setInterval () ->
        if document.readyState is "complete"
            clearInterval readyStateCheckInterval

            console.log "Hello. This message was sent from scripts/inject.jasds"


            # movie = $('.agMovie.agMovie-lulg').first().find("a")

            # $(".gallery").bind "DOMNodeInserted", ->
            #     console.log "child is appended"





            # movie.simulate 'mouseover'

            # anchor = movie.find("a") || movie
            # anchor.simulate 'mouseover'

            # $.ajax url: 'http://www.netflix.com/WiGenre?agid=7627', dataType: 'html', success: (result) ->

            #     serverDefs = /"serverDefs":{"data":({.*?}),"/gi
            #     object = serverDefs.exec result
            #     console.log 'inject', object[1]
            #     JSON.parse object[1]


        return
    , 10
    return

# init = () ->

#     # start listening to transmitions
#     msg = new TransmissionHandler

#     # Infiltrating to netflix.com...
#     Utils.injectScript "js/jquery/jquery.min.js"
#     Utils.injectScript "src/inject/js/controller.js"

#     #
#     actionHandler = new ActionHandler
#     if window.location.pathname.match "/WiHome"
#         controller = new HomeController
#     else if window.location.pathname.match "/WiGenre"
#         controller = new GenreController

#     testAPI = (movieID, trackID) ->
#         deferred = Q.defer()

#         # constants.loaded().then (data) ->
#         #     deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false
#         # , (error) ->
#         #     deferred.reject 0

#         if Constants.loaded
#             deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false
#         else
#             loadedConstantsInterval = setInterval () ->
#                 if typeof Constants.loaded is 'boolean'
#                     clearInterval loadedConstantsInterval
#                     deferred.resolve NetflixAPI.getMovieInfo movieID, trackID, false if not Constants.loaded
#             , 10

#         deferred.promise

#     testAPI('70180183', '13462047').fail (error) ->
#         if error is 404 or # APIKey isn't updated
#         error is 0 # Data is empty
#             msg.transmit 'MajorTom', 'OSN:Constants', 'fetch'

# init()








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