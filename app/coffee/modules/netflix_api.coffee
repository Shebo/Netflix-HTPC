'use strict'

define ["require", "jquery", "q", "watch", 'modules/utils', 'promise!modules/config', 'modules/handlers/event_handler'], (require, $, Q, WatchJS, Utils, Config, EventHandler) ->


    # EventHandler.on 'OSN:ConfigUpdated', (e) =>
    #     console.log "OSN:ConfigUpdated fired: ", Config.local.netflix
    #     NetflixAPI.conf = Config.local.netflix


    WatchJS.watch Config.local.netflix, (prop, action, newvalue, oldvalue) ->
        NetflixAPI.conf = @

    isRelative = true

    class NetflixAPI

        @conf       = Config.local.netflix
        @root       = if not isRelative then "#{if @conf.isSecure then "https" else "http"}://#{@conf.domain}/" else ''
        @APIRoot    = "#{@root}/#{@conf.APIRoot}/#{@conf.APIKey}"

        @getMovieInfo: (movieID, trackID, jquery=true, type='shakti') ->

            if jquery
                $.getJSON "#{@root}/#{@conf.APIRoot}/#{@conf.APIKey}/bob",
                    titleid: movieID
                    trackid: trackID
                    authURL: @conf.authURL
            else
                Utils.rawAjax "#{@root}/#{@conf.APIRoot}/#{@conf.APIKey}/bob?titleid=#{movieID}&trackid=#{trackID}&authURL=#{@conf.authURL}"


    # Test that api key is valid
    NetflixAPI.getMovieInfo(1, 1).fail (error) ->
        if error.status is 404 or # APIKey isn't updated
        error.status is 0 # Data is empty
            console.log 'need to update', Config
            Config.resetNetflix().then (data) ->
                NetflixAPI.conf = Config.local.netflix
