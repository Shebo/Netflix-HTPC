'use strict'

define ['require', "q", "underscore", 'promise!modules/injector', 'modules/default_sync_config', 'modules/utils', 'modules/handlers/event_handler', 'modules/handlers/transmission_handler', 'modules/handlers/storage_handler'], (require, Q, _, Injector, default_sync_config, Utils, Transmission, EventHandler, Storage) ->

    # resets storage data
    reset = (type) ->
        if type is 'local'
            Transmission.sendWait('Neo', 'OSN:ConfigGet')
            .then (result) ->
                config.set 'local', result.data
        else if type is 'sync'
            config.set 'sync', default_sync_config

    # test that storage data is following it's map
    test = (type, data) ->
        storage_map =
            local:
                netflix: ['APIKey', 'APIRoot', 'authURL', 'domain', 'isSecure', 'pages', 'serverDefs']
            sync:
                controls: ['up', 'down', 'left', 'right', 'enter', 'cancel']

        Utils.verifyObjectByMap data, storage_map[type]

    # save storage data into config object
    save = (result) ->
        type = result[0]
        data = result[1]
        config[type] = {}
        config[type][k] = v for k,v of data

        # EventHandler.fire "OSN:ConfigUpdated"


    config = {
        resetNetflix  : () -> reset('local')
        resetControls : () -> reset('sync')
        set: (type, data) ->
            Storage.set(type, data).then (result) ->
                save(result)
        get: (type) ->
            deferred = Q.defer()
            Storage.get(type).then (result) ->
                data = result[1]
                if test type, data
                    deferred.resolve [type, data]
                else
                    deferred.reject type
            deferred.promise
    }

    mainDeferred = Q.defer()

    promises = []

    localDeferred = Q.defer()
    syncDeferred = Q.defer()

    promises.push localDeferred.promise, syncDeferred.promise

    local = config.get('local')
    .then save
    , reset # local data isn't complete, ask agent neo for fresh data
    .then (data) -> syncDeferred.resolve true

    sync = config.get('sync')
    .then save
    , reset # sync data isn't complete, use default_sync_config
    .then (data) -> syncDeferred.resolve true


    Q.all([local, sync])
    .then (results) ->
        mainDeferred.resolve config

    mainDeferred.promise
