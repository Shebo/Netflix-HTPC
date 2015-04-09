

# readyStateCheckInterval = setInterval () ->
#     if document.readyState is "complete"
#         clearInterval readyStateCheckInterval

###
Inner page

netflix.contextData = {

    -------------API Inner page Constants---------------

    "serverDefs": {
        "data": {
            "cluster": "shakti-prod",
            "instance": "i-12d4b0c5",
            "region": "us-east-1",
            "cacheBust": false,
            "production": true,
            "API_BASE_URL": "/shakti",
            "BUILD_IDENTIFIER": "2a2d7eaa",                                     # special uniqe in api url
            "ICHNAEA_ROOT": "/ichnaea",
            "ICHNAEA_PROXY_ROOT": "/ichnaea",
            "host": "www.netflix.com",
            "SHAKTI_API_ROOT": "http://www.netflix.com/api/shakti",
            "API_ROOT": "http://www.netflix.com/api",
            "DVD_CO": "http://dvd.netflix.com/",
            "CDN_HOST": "http://cdn1.nflxext.com"
        }
    },

    ---------------User Auth Inner page Constants---------------

    "userInfo": {
        "data": {
            "authURL": "1428341996324.YOCOmtnuZuuaksensOkYkD1wgVk=",            # authenticated string
            "countryOfSignup": "US",
            "isDVD": false,
            "pinEnabled": false,
            "guid": "ENJOB4M54FBBNFVJSE2KOHQFOA",
            "masquerade": false
        }
    }

###

###
HOME

netflix.constants.page = {
    ESN: "NFCDCH-02-AJP0KJ4GUCUN1R4XPWT72EUDFA2PMK",
    MEMBER_GUID: "UEAOTKNXQRGILDUALBYMYT3Q7E",
    ibob: true,
    listBoxshotPlayId: 11802981,
    merchMdxJs: "http://cdn-0.nflximg.com/en_us/ffe/player/html/mdx_cros_v2_2.0000.115.011.js",
    resPullFreq: 10,
    siteSection: "watchnow",
    stringgroups: Object,
    usableListRowItems: 0,
    xsrf: "1428343163018.WirYQY0wVyaqx34YUxe4W823/o0="


netflix.BobMovieManager.constructBobFetchUrl($('#b070153380_0')) # jquery object of movie's a tag as param. returns a full URL with BOB details and HTML

netflix.XSRFSafeLink = {
    getXsrfToken()                            # authenticated string
    urlWithXSRF()                             # add authenticated string to url
    getQueryString()                          # build CDN url from relative path

###



###

Netflix Url Structre:

Example         : http://www.netflix.com/WiPlayer?movieid=60031274&trkid=13462293&tctx=2%2C39%2Cd1487862-5adb-435f-ba7e-7e8fd456495d-14962475
Decoded Example : http://www.netflix.com/WiPlayer?movieid=60031274&trkid=13462293&tctx=2,39,d1487862-5adb-435f-ba7e-7e8fd456495d-14962475

Structred Example: {port}://{domain}/{player}?movieid={movieid}&trkid={trkid}&tctx={movieIndex},{listIndex},{REQUEST_ID}
Parts:
    port: 'http'
    domain: 'www.netflix.com'
    player: 'WiPlayer'
    movieid: '60031274' # Netflix's movie ID, first segment in data-uitrack attribute of the movie's href
    trkid: '13462293' # ??? track ID, second segment in data-uitrack attribute of the movie's href
    movieIndex: 2 # index of movie in a list, third segment in data-uitrack attribute of the movie's href
    listIndex: 39 # index of list in a page, fourth segment in data-uitrack attribute of the movie's href (in home page 0 can be billboard)
    REQUEST_ID: 'd1487862-5adb-435f-ba7e-7e8fd456495d-14962475' # netflix.constants.page.REQUEST_ID

###

Home =
    AuthURL : netflix.contextData.userInfo.data.authURL
    getMovieData: netflix.contextData.serverDefs

Genre =
    AuthURL : netflix.contextData.userInfo.data.authURL



class EventHandler

    constructor: ->
    dispatch: (action) =>
        $.event.trigger
            type: "NetflixHTPC"
            action: action
        false

class TransmissionHandler extends EventHandler

    constructor: ->
        @source = 'MajorTom'
        @target = 'GroundControl'

        window.addEventListener 'message', @_recieve
        # window.addEventListener 'message', (e) =>
        #     @_recieveMessage(e)

    transmit: (message, action) =>
        # action = action || {}
        window.postMessage
            source: @source
            target: @target
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

    console.log Requireify._registry['js/utils/urls.js'].exports.getTitleUrl('Paycheck')


    eventsss =
        EVENT_TERM_CHANGED : "instantSearchTermChanged"
        EVENT_LOAD_FINISHED : "instantSearchLoadFinished"
        EVENT_NEEDS_MORE : "instantSearchNeedsMore"
        EVENT_CONTENT_COMPLETE : "instantSearchContentComplete"
        EVENT_RESULT_RCVD : "instantSearchResultReceived"
        EVENT_RESULT_SHOWN : "instantSearchResultShown"
        EVENT_NO_GALLERY_RESULTS : "instantSearchNoGalleryResults"
        EVENT_HAS_DVD_UPSELL : "instantSearchHasDVDUpsell"
        EVENT_FETCH : "instantSearchFetch"
        EVENT_RENDERED : "instantSearchRendered"


    document.addEventListener "uiModalViewChanged",(e) ->
      # // e.target matches document from above
      console.log e
    $(document).on "uiModalViewChanged", (e) =>
        console.log e

    document.addEventListener "instantSearchContentComplete",(e) ->
      # // e.target matches document from above
      console.log e
    $(document).on "instantSearchContentComplete", (e) =>
        console.log e

    document.addEventListener "instantSearchFetch",(e) ->
      # // e.target matches document from above
      console.log e
    $(document).on "instantSearchFetch", (e) =>
        console.log e

    for k,v of eventsss
        console.log v
        # // Listen for the event.
        document.addEventListener v,(e) ->
          # // e.target matches document from above
          console.log e
        , false
        $(document).on v, (e) =>
            console.log e



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


