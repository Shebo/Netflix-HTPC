'use strict'

define ["q"], (Q) ->
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
