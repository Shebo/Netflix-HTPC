'use strict';

shortcuts = {}
alertMsgs = {
    success: "<strong>Yatta!</strong> Shortcuts saved successfully."
    missing_shortcut:  "<strong>Oh Snap, Linden!</strong> Looks like you didn't set all the needed shortcuts."
    duplicate_shortcut:  "<strong>Great Scott!</strong> Looks some of your shortcuts are duplicates."
}
inputs = []
supportGamepad = false

carouselNormalization = ->
    items = $ '#shortcuts-carousel .item' #grab all slides
    heights = [] #create empty array to store height values
    tallest = 0 #create variable to make note of the tallest slide

    if items.length
        normalizeHeights = ->
            items.each () -> # add heights to array
                heights.push($(this).height())

            tallest = Math.max.apply null, heights #cache largest value
            items.each () ->
                $(this).css 'min-height',tallest + 'px'


        normalizeHeights()

        $(window).on 'resize orientationchange',  () ->
            tallest = 0
            heights.length = 0 #reset vars
            items.each () ->
                $(this).css('min-height','0') #reset min-height
            normalizeHeights() #run it again

capitalizeFirstLetter = (string) ->
    string.charAt(0).toUpperCase() + string.slice(1)

isEmpty = (variable) ->
    not (variable?.length)

mapToKeyName = (code) ->

    # get key name/s
    name = KeyboardJS.key.name(code)

    if($.isArray(name))
        if code == 91 || code == 92 # if pressed key is windows key
            key = name[2]
        else if (code >= 48 && code <= 57) || (code >= 96 && code <= 111) # if pressed key is a number or from numpad
            key = name[name.length-1]
        else if (code >= 186 && code <= 192) || (code >= 219 && code <= 222) # if pressed key is special sign
            key = name[name.length-1]
        else
            key = name[0]
    else
        key = name;

    key

clearInput = () ->
    $(this).closest('div').find('input').val ''

alert = (type, msg) ->
    msg = type if not msg
    $('.alert-wrapper').prepend("<div class='alert alert-"+type+" alert-dismissable center-block top in animated slideInDown'>\
        <button type='button' class='close' aria-label='Close' data-dismiss='alert'><span aria-hidden='true'>&times;</span></button>\
        <span>"+alertMsgs[msg]+"</span>\
    </div>")
    $alert = $('.alert-wrapper').children().first()
    setTimeout ->
        $alert.alert('close')
    , 5000

update = (event) ->
    event.preventDefault()
    setTimeout ->
        keys = []

        for k, v of KeyboardJS.activeKeys() when KeyboardJS.key.code(v)
            key = KeyboardJS.key.code(v)
            if key.length and key not in keys
                keys.push key

        keys = keys.map(mapToKeyName)

        keysString = keys.join ' + '
        $(event.target).val keysString
    , 0

validate = (event) ->
    # cancel browser submition
    event.preventDefault()

    values = []

    for input in inputs
        val = $(input).val()

        if isEmpty val # no empty inputs allowed
            return alert 'danger', 'missing_shortcut'
        else if val in values # no duplicated inputs allowed
            return alert 'danger', 'duplicate_shortcut'

        values.push val
    set()

# Saves options to chrome.storage
set = ->
    $('#save').button 'loading'
    for input in inputs
        shortcuts[$(input).attr('name')] = $(input).val()

    chrome.storage.sync.set shortcuts, ->
        $('#save').button 'reset'
        alert 'success'

setMode = (event) ->
    chrome.storage.sync.set {navMode: $(this).children('input').attr('id')}

# Restores select box and checkbox state using the preferences
# stored in chrome.storage.
getChromeStorage = ->
    for input in inputs
        shortcuts[$(input).attr('name')] = $(input).val()

    chrome.storage.sync.get shortcuts, (items) ->
        for input in inputs
            $(input).val(items[$(input).attr('name')])
        $('body').removeClass 'loading'

initGamepad = ->
    gamepad = new Gamepad()

    if not gamepad.init()
        return

    $('.no-gamepad-support').addClass 'hidden'
    $('.gamepad-support').removeClass 'hidden'

    $('.gamepad-status-disconnected').removeClass 'hidden'

    gamepad.bind Gamepad.Event.CONNECTED, (device) ->
        console.log "CONNECTED", device
        $('.gamepad-status').addClass 'hidden'
        $('.gamepad-status-connected').removeClass 'hidden'

    gamepad.bind Gamepad.Event.DISCONNECTED, (device) ->
        console.log "DISCONNECTED", device
        $('.gamepad-status').addClass 'hidden'
        $('.gamepad-status-disconnected').removeClass 'hidden'


    gamepad.bind Gamepad.Event.UNSUPPORTED, (device) ->
        console.log "UNSUPPORTED", device
        $('.gamepad-status').addClass 'hidden'
        $('.gamepad-status-unsupported').removeClass 'hidden'


    gamepad.bind Gamepad.Event.BUTTON_DOWN, (e) ->
        console.log "BUTTON_DOWN", e
    gamepad.bind Gamepad.Event.BUTTON_UP, (e) ->
        console.log "BUTTON_UP", e
    gamepad.bind Gamepad.Event.AXIS_CHANGED, (e) ->
        console.log "AXIS_CHANGED", e

    supportGamepad = not not gamepad.init()

$( document ).ready ->
    inputs = $(".keyboard-input")
    ###
    Init Components
    ###
    initGamepad()
    getChromeStorage() # Get saved Shortcuts
    $('[data-toggle="tooltip"]').tooltip() # init bootstarp tooltips
    carouselNormalization() # fix bootstrap carousel height problem

    ###
    Register Event Handlers
    ###
    inputs.on 'keydown', update # register pressed keys
    $(".mode-btns .btn").click setMode # save inputs to chrome
    $('form').submit validate # save inputs to chrome
    $('.clear-input').click clearInput # delete input value