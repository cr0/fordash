define (require, exports) ->
  'use strict'

  require 'backbone-relational'

  Chaplin       = require 'chaplin'

  exports.Model = class Model extends Backbone.RelationalModel
    _.extend @prototype, Chaplin.EventBroker
    _.extend @prototype, Chaplin.SyncMachine
    
    attributes = ['getAttributes', 'serialize', 'disposed']
    for attr in attributes
      @::[attr] = Chaplin.Model::[attr]

    idAttribute: 'id'

    dispose: ->
      return if @disposed
      @trigger 'relational:unregister', @, @collection
      Chaplin.Model::dispose.call(@)

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

    # make usage of save more comfortable
    save: (cb, attributes = {}) ->
      super attributes, cb

