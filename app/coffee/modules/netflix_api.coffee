'use strict'

define ["jquery", "q", 'modules/utils', 'modules/constants'], ($, Q, Utils, Constants) ->
    class NetflixAPI
        @isRelative = true

        @_getRoot: =>
            if not @isRelative then "#{if Constants.isSecure then "https" else "http"}://#{Constants.domain}/" else ''

        @_getAPIRoot: =>
            "#{@_getRoot()}/#{Constants.APIRoot}/#{Constants.APIKey}"

        @getMovieInfo: (movieID, trackID, jquery=true, type='shakti') ->

            if jquery
                Q $.getJSON "#{@_getRoot()}/#{Constants.APIRoot}/#{Constants.APIKey}/bob",
                    titleid: movieID
                    trackid: trackID
                    authURL: Constants.authURL
            else
                Utils.rawAjax "#{@_getRoot()}/#{Constants.APIRoot}/#{Constants.APIKey}/bob?titleid=#{movieID}&trackid=#{trackID}&authURL=#{Constants.authURL}"