'use strict'

# handling all keyboard actions
define ["jquery", "watch", "KeyboardJS", 'promise!modules/config', 'modules/handlers/event_handler'], ($, WatchJS, KeyboardJS, Config, EventHandler) ->


    isAllowed = true

    WatchJS.watch Config.local.netflix, (prop, action, newvalue, oldvalue) ->
        NetflixAPI.conf = @

    # EventHandler.on 'OSN:ConfigUpdated', (e) =>
    #     console.log "OSN:ConfigUpdated fired: ", Config.sync.controls
    #     ActionHandler.controls = Config.sync.controls

    class ActionHandler extends EventHandler

        @controls = Config.sync.controls

        # get all user's registerd action combos and bind them
        @_initShortcuts: =>
            for action, combo of @controls
                @_bindShortcuts action, combo

        # create listeners that disable/enable use if controls
        @_initActionBlocker: =>
            @isAllowed = true
            # deny action if in input/textarea/utton element is focused on
            $(":input").focus (e) => @isAllowed = false
            # re-allow action if in input/textarea/utton element is focused out
            $(":input").blur (e) => @isAllowed = true

        # this method exist only because Keyboard.JS bug
        # every action in the callback that under a loop - get's overriden by the last action
        @_bindShortcuts: (action, combo) =>
            KeyboardJS.on combo, (e) =>
                @fire 'OSN:Controls', {action: action} if @isAllowed

        @_initShortcuts()
        @_initActionBlocker()