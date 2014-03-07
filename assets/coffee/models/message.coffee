define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'
  Moment          = require 'moment'

  Model           = require 'models/base/model'


  ###*
   * Class representing a {Message}
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Message extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "messages/id/"

    defaults:
      body:   '<UNKNOWN_BODY>'
      direction:  '<UNKNOWN_DIRECTION>'
      read:   no
      type:   '<UNKNOWN_TYPE>'
      date:   '<UNKNOWN_DATE>'


    ###*
     * Remap attributes send from server to a more intuitive name
     *
     * @type {Object}
    ###
    mapping:
      'messagetype':  'direction'
      'messageMedium':'type'
      'body':         'text'


    ###*
     * Create new {Message}
     *
     * @param  {Object} A classic backbone constructor options hash
     * @return {Message}
    ###
    initialize: (options) ->
      @on 'change:date', @updateFormattedDate, @


    ###*
     * Helper method for updating the {Message#formatted_date} value. This property is normally used to output a date
     * in views
     *
     * @param  {Message} model  The current {Message} instance
     * @param  {Date} value     The new value of {Message#date}
     * @param  {Object} options
     * @return {Message} The current {Message} instance
     * @private
    ###
    updateFormattedDate: (model, value, options) ->
      # Thu Jan 02 13:10:56 CET 2014
      @set 'formatted_date', "#{Moment.unix(value/1000).format('D. MMM YYYY, HH:mm:ss')} Uhr" if value?
