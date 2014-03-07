define (require) ->
  'use strict'

  Chaplin             = require 'chaplin'

  Dumps               = require 'models/dumps'

  HeaderView          = require 'views/header-view'
  ErrorView           = require 'views/error-view'
  SkeletonView        = require 'views/skeleton-view'
  DumpSelectView      = require 'views/dump/select-view'


  ###*
   * Base controller providing two regions: header and site
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class Controller extends Chaplin.Controller

    ###*
     * Create regions
     *
     * @param  {Object} params Route variables and GET Parameters
     * @param  {String} route Current route
     * @private
    ###
    beforeAction: (params, route) ->
      new ErrorView
      @reuse 'header', HeaderView
      @reuse 'site', SkeletonView
      @reuse 'loader', DumpSelectView, region: 'loader', collection: new Dumps


    ###*
     * When dumpid changes, change the corresponding {Chaplin.Mediator}'s value
     *
     * @return {Chaplin.Controller}
    ###
    initialize: ->
      console.debug "Subscribing to dumpid changes"
      Chaplin.mediator.subscribe 'dumpid:change', (value) ->
        Chaplin.mediator.dumpid = value
        console.log "Dumpid changed to #{value}"

      super


