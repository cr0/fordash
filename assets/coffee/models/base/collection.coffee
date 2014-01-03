define (require, exports) ->
  'use strict'

  Chaplin       = require 'chaplin'
  Model         = require 'models/base/model'

  exports.Collection = class Collection extends Chaplin.Collection
    _.extend @prototype, Chaplin.SyncMachine

    model: Model

    initialize: (options = {}) ->
      @url = options.url if options.url?

    fetch: (options = {}) ->
      @beginSync()

      success = options.success
      denied = options.denied
      error = options.error

      options.success = (collection, response, options) =>
        success? collection, response, options
        @finishSync()

      options.error = (collection, response, options) =>
        if response.status is 401 or 403 and typeof denied is 'function' then denied? collection, response, options
        else error? collection, response, options
        @abortSync()

      super options

    parse: (json) ->
      if json.data then json.data else json

    # make usage of save more comfortable
    save: (cb, attributes = {}) ->
      super attributes, cb