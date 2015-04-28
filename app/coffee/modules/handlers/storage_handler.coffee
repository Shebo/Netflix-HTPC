'use strict'

define ["q", "underscore"], (Q, _) ->

    class Config

        @get: (type, names=null) ->

            deferred = Q.defer()

            switch type
                when 'sync'   then storage = chrome.storage.sync
                when 'local'  then storage = chrome.storage.local
                else null

            storage.get names, (data) -> deferred.resolve [type, data]

            deferred.promise

        @set: (type, data) ->

            deferred = Q.defer()

            switch type
                when 'sync'   then storage = chrome.storage.sync
                when 'local'  then storage = chrome.storage.local
                else null

            storage.set data, () -> deferred.resolve [type, data]

            deferred.promise