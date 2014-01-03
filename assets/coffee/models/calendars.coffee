define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Calendar      = require 'models/calendar'


  class Calendars extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/calendars/#{Chaplin.mediator.dumpid}/all"
    model:  Calendar
