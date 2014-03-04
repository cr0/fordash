define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'


  ###*
   * Class representing a {Calendar} event like a meeting
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Calendar extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/calendars/id/"

    defaults:
      title:          '<UNKNOWN_TITLE>'
      description:    null
      start:          '<UNKNOWN_START_DATE>'
      stop:           '<UNKNOWN_STOP_DATE>'
      location:       '<UNKNOWN_LOCATION>'

    mapping:
      'stop':         'end'


