define (require, exports) ->
  'use strict'

  require 'backbone-relational'

  Chaplin       = require 'chaplin'


  ###*
   * A base {Chaplin.Model} class extending {Backbone.RelationalModel}
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
   * @include Chaplin.SyncMachine
  ###
  exports.Model = class Model extends Backbone.RelationalModel
    _.extend @prototype, Chaplin.EventBroker
    _.extend @prototype, Chaplin.SyncMachine

    attributes = ['getAttributes', 'serialize', 'disposed']
    for attr in attributes
      @::[attr] = Chaplin.Model::[attr]

    idAttribute: 'id'


    ###*
     * Dispose a model and signal Backbone.Relational that any attached collection/model should be disposed, too
     *
     * @event relational:unregister
    ###
    dispose: ->
      return if @disposed
      @trigger 'relational:unregister', @, @collection
      Chaplin.Model::dispose.call(@)


    ###*
     * Fetch the model from the server
     *
     * @param  {Object} options = {} Hash with callbacks for success, error and denied (optional)
     * @return {jQuery.Deferred} A jQuery Deferred object used to chain following events (load, fail, ...)
    ###
    fetch: (options = {}) ->
      class ServerError extends Error
        constructor: (@name, @code, @message, @stack) ->

      @beginSync()

      success = options.success
      denied = options.denied
      error = options.error

      options.success = (model, response, options) =>
        success? model, response, options
        @finishSync()

      options.error = (model, response, options) =>
        json     = response.responseJSON?.error
        if json?
          response = new ServerError json.name, json.code, json.message, json.details?.stack
          if response.status is 401 or 403 and typeof denied is 'function' then denied? model, response, options
        else error? model, response, options
        @abortSync()

      super options


    ###*
     * Wrap the save event to be easier to use
     *
     * @param  {Object} db Hash with callbacks for success, error and denied (optional)
     * @param  {Object} attributes = {} Additional properties for the {jQuery#ajax} method
     * @return {jQuery.Deferred} A jQuery Deferred object used to chain following events (load, fail, ...)
    ###
    save: (cb, attributes = {}) ->
      super attributes, cb


    ###*
     * Set a attribute on the current model. Uses a model's mapping table property to rename attributes caught from the
     * server.
     *
     * @param {String} key The name of the attribute to set (will be renamed according to the mapping table)
     * @param {Object} val The value of the attribute to set
     * @param {Object} options Additional properties
    ###
    set: (key, val, options) ->
      @mapping = {} if not @mapping

      if typeof key is 'object'
        for from, to of @mapping
          if from of key
            key[to] = key[from]
            delete key[from]
      else
        key = @mapping[key] if key of @mapping

      super key, val, options

