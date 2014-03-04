define (require) ->
  'use strict'

  Chaplin = require 'chaplin'
  utils   = require 'lib/utils'


  ###*
   * The forDASH application
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class Application extends Chaplin.Application
    title: 'forDASH'

    ###*
     * Create a new forDASH application
     *
     * @param  {Object} options = {} A {Chaplin.Application} object hash
     * @return {Application}
    ###
    initialize: (options = {}) ->
      @setApiRoot options.apiRoot if options.apiRoot?
      super


    ###*
     * Add some cross application properties to the {Chaplin.Mediator}. {Chaplin.Mediator} is sealed afterwards
     * prohibiting its extension.
    ###
    initMediator: ->
      Chaplin.mediator.dumpid = utils.uuid4()
      Chaplin.mediator.cid = null
      console.debug "Setting dumpid to #{Chaplin.mediator.dumpid}"
      super

    ###*
     * Set the url to the backend providing the data
     *
     * @param {String} apiRoot
    ###
    setApiRoot: (apiRoot) ->
      @apiRoot = apiRoot
      @apiRoot = "#{@apiRoot}/" unless /\/$/.test @apiRoot
      console.info "Using #{@apiRoot} as API backend"

      bbSync = Backbone.sync
      Backbone.sync = (method, model, options) =>
        options = _.extend options,
          url: @apiRoot + if _.isFunction(model.url) then model.url() else model.url
          beforeSend: (xhr) -> xhr.setRequestHeader 'Authorization', "Token token=FAIL-NO-TOKEN-N33DED"

        bbSync method, model, options
