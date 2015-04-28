require.config({
  // waitSeconds: 20,
  baseUrl: chrome.extension.getURL(''),
  waitSeconds: 60,
  shim: {
    simulate   : 'jquery',
    bootstrap  : 'jquery'
  },
  paths: {
    // almond     : '../bower_components/almond/almond',
    // text       : '../bower_components/requirejs-plugins/lib/text',
    // async      : '../bower_components/requirejs-plugins/src/async',
    // json       : '../bower_components/requirejs-plugins/src/json',
    promise    : '../bower_components/requirejs-promise/requirejs-promise',
    jquery     : '../bower_components/jquery/dist/jquery',
    q          : '../bower_components/q/q',
    simulate   : '../bower_components/jquery-simulate/jquery-simulate',
    underscore : '../bower_components/underscore/underscore',
    bootstrap  : '../bower_components/bootstrap/dist/js/bootstrap',
    KeyboardJS : '../bower_components/KeyboardJS/keyboard',
    gamepad    : '../bower_components/HTML5-JavaScript-Gamepad-Controller-Library/gamepad'
    // jsonp: '../bower_components/jsonp/jsonp',

    // leaflet: '../bower_components/leaflet/dist/leaflet',
    // mediaelement: '../bower_components/mediaelement/build/mediaelement',
    // moment: '../bower_components/momentjs/moment'
  },
  packages: [

  ]
});