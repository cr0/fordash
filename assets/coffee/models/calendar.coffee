define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Calendar extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/calendars/id/"

    defaults:
      title:          '<UNKNOWN_TITLE>'
      description:    null
      start:          '<UNKNOWN_START_DATE>'
      stop:           '<UNKNOWN_STOP_DATE>'
      location:       '<UNKNOWN_LOCATION>'

