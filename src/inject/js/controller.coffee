

class Utils

    @rawAjax: (url, callback) ->
        request = new XMLHttpRequest()
        request.open 'GET', url, true

        request.onload = () ->
          if request.status >= 200 && request.status < 400
            callback request.responseText

        request.send()

    @parseURL: (url) ->
        parser       = document.createElement('a')
        searchObject = {}
        parser.href  = url
        queries      = parser.search.replace(/^\?/, '').split '&'

        for query in queries
            split = query.split('=')
            searchObject[split[0]] = split[1]

        object =
            protocol     : parser.protocol,
            host         : parser.host,
            hostname     : parser.hostname,
            port         : parser.port,
            pathname     : parser.pathname,
            search       : parser.search,
            searchObject : searchObject,
            hash         : parser.hash

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

# Home =
#     AuthURL : netflix.contextData.userInfo.data.authURL
#     getMovieData: netflix.contextData.serverDefs

# Genre =
#     AuthURL : netflix.contextData.userInfo.data.authURL

class EventHandler
    constructor: ->
    dispatch: (type, action, info = undefined) =>
        # safe dispatch - dispatch event only after jQuery ($ object) is loaded
        if $? then @_safeDispatch(type, action, info)
        else
            dispatchInterval = setInterval () ->
                if $?
                    clearInterval dispatchInterval
                    @_safeDispatch(type, action, info)
            , 10

    _safeDispatch: (type, action, info) =>
        $.event.trigger
            type   : type
            action : action
            info   : info
        false

class TransmissionHandler extends EventHandler

    constructor: ->
        @source = 'MajorTom'
        # @types = ['request', 'response']

        # @target = 'GroundControl'

        window.addEventListener 'message', @_recieve
        # window.addEventListener 'message', (e) =>
        #     @_recieveMessage(e)

    transmit: (target, type, action, data = null) =>
        window.postMessage
            sender    : @source
            recipient : target
            action    : action
            type      : type
            data      : data
            , '*'

    _recieve: (event) =>
        msg = event.data

        @dispatch msg.type, msg.action, msg.data
        if msg.recipient is @source
            if msg.type is 'OSN:Constants' and msg.action is 'fetch'
                fetchConstants()

            # if msg.type is 'request'
            #     @transmit msg.from, 'response', InjectedAPI[msg.action]()
            # else if msg.type is 'response'
            #     console.log 'response'



pagesTypes  =
    home   : "WiHome"
    genre  : "WiGenre"
    movie  : "WiMovie"
    player : "WiPlayer"
    player : "WiPlayer"
    search : "WiSearch"
    role   : "WiRoleDisplay"

class NetflixData

    constructor: ->
        @obj =
            domain   : 'www.netflix.com'
            pages    : pagesTypes

class NetflixHomeData extends NetflixData

    constructor: ->
        super
        @obj.isSecure = netflix.XSRFSafeLink.isSecure()
        @obj.authURL  = netflix.XSRFSafeLink.getXsrfToken()
        @_initServerDefs()

    _initServerDefs : =>
        url = Utils.parseURL document.getElementById("instantSearchTemplate").innerHTML.match(/<a\s+(?:[^>]*?\s+)?href="([^"]*)"/i)[1]
        Utils.rawAjax "#{if @obj.isSecure then "https" else "http"}://#{@obj.domain}/#{@obj.pages.genre}?agid=#{url.searchObject.agid}", (request) =>
            serverDefs      = /"serverDefs":{"data":({.*?}),"/gi
            @obj.serverDefs = JSON.parse serverDefs.exec(request)[1]
            @obj.APIRoot    = @obj.serverDefs.SHAKTI_API_ROOT.replace("#{if @obj.isSecure then "https" else "http"}://#{@obj.domain}/", "")
            @obj.APIKey     = @obj.serverDefs.BUILD_IDENTIFIER

class NetflixInnerData extends NetflixData

    constructor: ->
        super
        @obj.isSecure   = location.protocol is "https:"
        @obj.authURL    = netflix.contextData.userInfo.data.authURL
        @obj.serverDefs = netflix.contextData.serverDefs
        @obj.APIRoot    = @obj.serverDefs.SHAKTI_API_ROOT
        @obj.APIKey     = @obj.serverDefs.BUILD_IDENTIFIER



msg = new TransmissionHandler

if window.location.pathname.match "WiHome"
    netflixData = new NetflixHomeData
else if window.location.pathname.match "WiGenre"
    netflixData = new NetflixInnerData


fetchConstants = ->
    dataFetcherInterval = setInterval () ->
        if netflixData.obj.serverDefs
            clearInterval dataFetcherInterval
            msg.transmit 'GroundControl', 'OSN:Constants', 'update', netflixData.obj
    , 10

#

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

    # console.log Requireify._registry['js/utils/urls.js'].exports.getTitleUrl('Paycheck')

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


    # $(document).on netflix.sliders.htmlReadyEvent, (e) =>
    #     console.log "jquery event:", e
    # $(document).on netflix.GlobalHeader.hideMenuEvent, (e) =>
    #     console.log "GlobalHeader.hideMenuEvent event:", e
    # $(document).on netflix.GlobalEvents.resumeAnimationLoops, (e) =>
    #     console.log "GlobalEvents.resumeAnimationLoops event:", e


