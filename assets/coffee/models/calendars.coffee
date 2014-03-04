define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Calendar      = require 'models/calendar'


  ###*
   * Class representing a collection of {Calendar}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Calendars extends Collection
    _.extend @prototype, Chaplin.EventBroker

    model:  Calendar


    ###*
     * Query all {Calendar} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Calendars}
    ###
    @forDump: (dumpid) ->
    	return new Calendars url: "#{Chaplin.mediator.urlprefix}/calendars/#{dumpid}/all"
