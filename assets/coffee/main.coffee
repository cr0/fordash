require.config

  waitSeconds: 15
  baseUrl: '/js/'

  paths:
    # addons
    async:      '../vendor/requirejs/async',
    goog:       '../vendor/requirejs/goog',
    links:      '../vendor/timeline/timeline'

  shim:
    backbone:
      deps: ['underscore', 'jquery'],
      exports: 'Backbone'
    underscore:
      exports: '_'
    d3:
      exports: 'd3'
    nvd3:
      deps: ['d3']
      exports: 'nv'
    links:
      exports: 'links'

  map:
    '*':
      'underscore': 'lodash'
#      
      
define 'gmaps', ['async!http://maps.google.com/maps/api/js?v=3&key=AIzaSyAPioLTf2snn7k023uPTMreFY-y1e0M10g&sensor=false'], () -> return window.google.maps

require ['application', 'routes'], (Application, routes) ->

  console.log "Booting app..."

  app = new Application
    routes: routes,
    controllerSuffix: '-controller'
    pushState: yes

  console.log app