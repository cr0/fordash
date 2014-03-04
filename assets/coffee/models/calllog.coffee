define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'
  Moment          = require 'moment'

  Model           = require 'models/base/model'


  ###*
   * Class representing a {Calllog} event like an incoming call
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Calllog extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "calllogs/id/"

    defaults:
      duration:   -1
      direction:  '<UNKNOWN_DIRECTION>'
      date:       '<UNKNOWN_DATE>'

    mapping:
      'callType': 'direction'


    ###*
     * Create new {Calllog}
     *
     * @param  {Object} A classic backbone constructor options hash
     * @return {Calllog}
    ###
    initialize: (options) ->
      @on 'change:date', @_updateFormattedDate, @


    ###*
     * Helper method for updating the {Calllog#formatted_date} value. This property is normally used to output a date
     * in views
     *
     * @param  {Calllog} model  The current {Calllog} instance
     * @param  {Date} value     The new value of {Calllog#date}
     * @param  {Object} options
     * @return {Calllog} The current {Calllog} instance
     * @private
    ###
    _updateFormattedDate: (model, value, options) ->
      # Thu Jan 02 13:10:56 CET 2014
      @set 'formatted_date', "#{Moment.unix(value/1000).format('D. MMM YYYY, HH:mm:ss')} Uhr" if value?
