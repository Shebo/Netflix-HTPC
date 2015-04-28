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

        @getUniqueId: () ->
            Date.now()

        @verifyObjectByMap = (obj, arr) ->
            for key,value of obj
                if _.isObject(value)
                    if key in _.keys(arr)
                        arr[key] = @verifyObjectByMap value, arr[key]
                        delete arr[key] if _.isEmpty arr[key]
                else
                    arr = _.without(arr, key) if key in arr
            _.isEmpty arr

        @injectScript: (path) ->
            deferred = Q.defer()

            script = document.createElement "script"
            script.src = chrome.extension.getURL path
            script.onload = () -> deferred.resolve true

            document.head.appendChild script

            deferred.promise

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
            deferred.promise