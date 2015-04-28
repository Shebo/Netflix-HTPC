'use strict'

define ["modules/utils"], (Utils) ->

	# Plan A - return original promise

    # Infiltrating the netflix...
    Utils.injectScript("scripts/inject/injected.js")


    # Plan B - use Defers

    # deferred = Q.defer()
    #
    # Infiltrating the netflix...
    # Utils.injectScript("scripts/inject/injected.js")
    # .then (results) ->
    #     deferred.resolve true
    #
    # deferred.promise


    # Plan C - use Q.all

    # deferred = Q.defer()
    #
    # # Infiltrating the netflix...
    # Q.all [Utils.injectScript("scripts/inject/injected.js")]
    # .then (results) ->
    #     deferred.resolve true
    #
    # deferred.promise