define (require, exports) ->
  'use strict'

  Chaplin       = require 'chaplin'
  Model         = require 'models/base/model'


  ###*
   * A base {Chaplin.Collection} class
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.SyncMachine
  ###
  exports.Collection = class Collection extends Chaplin.Collection
    _.extend @prototype, Chaplin.SyncMachine

    model: Model


    ###*
     * Create new {Collection} with an optional url property in the options hash
     *
     * @param  {Object} A classic backbone constructor options hash with url property
     * @return {Collection}
    ###
    initialize: (options = {}) ->
      @url = options.url if options.url?


    ###*
     * Fetch the collection from the server
     *
     * @param  {Object} options = {} Hash with callbacks for success, error and denied (optional)
     * @return {jQuery.Deferred} A jQuery Deferred object used to chain following events (load, fail, ...)
    ###
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


    ###*
     * Parse a {Collection} from the server. Correctly handle server wrapping the collection in a data object.
     *
     * @param  {JSON} json The json from the server
     * @return {JSON} Correct json for creating a {Collection}
    ###
    parse: (json) ->
      if json.data then json.data else json


    ###*
     * Wrap the save event to be easier to use
     *
     * @param  {Object} db Hash with callbacks for success, error and denied (optional)
     * @param  {Object} attributes = {} Additional properties for the {jQuery#ajax} method
     * @return {jQuery.Deferred} A jQuery Deferred object used to chain following events (load, fail, ...)
    ###
    save: (cb, attributes = {}) ->
      super attributes, cb
