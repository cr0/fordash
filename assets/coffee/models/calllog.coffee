define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'
  Moment          = require 'moment'

  Model           = require 'models/base/model'
  

  class Calllog extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/calllogs/id/"

    defaults:
      duration:   -1
      direction:  '<UNKNOWN_DIRECTION>'
      date:       '<UNKNOWN_DATE>'

    mapping:
      'callType': 'direction'

    initialize: (options) ->
      @on 'change:date', @updateFormattedDate, @

    updateFormattedDate: (model, value, options) ->
      # Thu Jan 02 13:10:56 CET 2014
      @set 'formatted_date', "#{Moment.unix(value/1000).format('D. MMM YYYY, HH:mm:ss')} Uhr" if value? 

