'use strict'

define ["jquery", "q", "underscore"], ($, Q, _, TransmissionHandler) ->




    class Constants

        # constructor: ->

        @keys = [
            'domain'
            'pages'
            'isSecure'
            'authURL'
            'serverDefs'
            'APIRoot'
            'APIKey'
            'loading'
        ]

        @msg = new TransmissionHandler('GroundControl')

        chrome.storage.local.get (data) =>
            @save(data)

        $(document).on "OSN:Constants", (e) =>
            if e.action is 'update'
                chrome.storage.local.set e.info, () =>
                    @save(e.info)

        @save: (data) =>
            console.log 'saving data', data
            @[k] = v for k, v of data
            if _.isEmpty _.difference Constants.keys, _.keys(data)
                @loading = false
            else
                console.log 'saving data not complete'
                @msg.transmit 'MajorTom', 'OSN:Constants', 'fetch'

        # getNetflixData: =>
        #     deferred = Q.defer()

        #     chrome.storage.local.get 'netflixData', (data) =>
        #         if not _.isEmpty data
        #             # @saveNetflixData data['netflixData']
        #             deferred.resolve data.netflixData
        #         else
        #             deferred.reject()

        #     deferred.promise

        # # setNetflixData: (data, callback) =>
        # #     chrome.storage.local.set netflixData: data, callback

        # saveNetflixData: (data) =>
        #     @[k] = v for k, v of data
