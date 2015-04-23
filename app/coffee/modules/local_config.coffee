'use strict'

define ["jquery", "q", "underscore"], ($, Q, _) ->

    deferred = Q.defer()

    local = Q.defer()
    sync = Q.defer()
    promises = []
    promises.push local.promise
    promises.push sync.promise

    # setTimeout ->
    #     console.log 'local is over'
    #     deferred.resolve 'YESSS'
    #     return
    #     # deferred.reject request.status
    # , 2000



    chrome.storage.local.get (data) =>
        console.log 'local', data
        local.resolve data
        true

    chrome.storage.sync.get (data) =>
        console.log 'sync', data
        sync.resolve data
        true

    # Q.all(promises).then (result) ->
    #     console.log 'all', result
    #     deferred.resolve result

    Q.spread promises, (local, sync) ->
        console.log 'spread', _.extend local, sync
        deferred.resolve _.extend local, sync

    deferred.promise

     # $q.all(promises).then(function (result) {
         # console.log('all promises returnd');
         # console.log(result);
         # defer.resolve(true);
     # });

# return Q.spread([a, b], function (a, b) {
    #     return a + b;
    # })