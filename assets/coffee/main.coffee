require.config

  waitSeconds: 15
  baseUrl: '/js/'

  paths:
    # addons
    links:             '../vendor/timeline/timeline'
    'jquery.preload':  '../vendor/jquery.preload'

  shim:
    d3:
      exports: 'd3'
    nvd3:
      deps: ['d3']
      exports: 'nv'
    links:
      exports: 'links'
    'jquery.preload':
      deps:   ['jquery']
    'jquery.exif':
      deps:   ['jquery']

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
    root: '/'
    apiRoot: '//localhost:8080/android-forensic-server/rest/'

  console.log app
