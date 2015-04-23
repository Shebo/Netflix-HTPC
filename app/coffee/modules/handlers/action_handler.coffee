'use strict'

# handling all keyboard actions
define ["jquery", "KeyboardJS", 'modules/handlers/event_handler'], ($, KeyboardJS, EventHandler) ->

    class ActionHandler extends EventHandler

        constructor: ->
            super
            @actions = [
                'left', 'up', 'right', 'down'
                'ok', 'cancel'
            ]
            @_initShortcuts()
            @_initActionBlocker()

        # get all user's registerd action combos and bind them
        _initShortcuts: =>
            chrome.storage.sync.get @actions, (shortcuts) =>
                for action, combo of shortcuts
                    @_bindShortcuts action, combo
                true

        _initActionBlocker: =>
            @isAllowed = true
            # deny action if in input/textarea/utton element is focused on
            $(":input").focus (e) => @isAllowed = false
            # re-allow action if in input/textarea/utton element is focused out
            $(":input").blur (e) => @isAllowed = true

        # this method exist only because Keyboard.JS bug
        # every action in the callback that under a loop - get's overriden by the last action
        _bindShortcuts: (action, combo) =>
            KeyboardJS.on combo, (e) =>
                @dispatch 'OSN:Controls', action if @isAllowed
