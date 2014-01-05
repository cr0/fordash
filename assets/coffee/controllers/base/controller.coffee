define (require) ->
  'use strict'

  Chaplin             = require 'chaplin'

  HeaderView          = require 'views/header-view'
  SkeletonView        = require 'views/skeleton-view'
  

  class Controller extends Chaplin.Controller
    beforeAction: (params, route) ->
      @compose 'header', HeaderView
      @compose 'site', SkeletonView

    initialize: ->
      console.debug "Subscribing to dumpid changes"
      Chaplin.mediator.subscribe 'dumpid:change', (value) -> 
        Chaplin.mediator.dumpid = value
        console.log "Dumpid changed to #{value}"


