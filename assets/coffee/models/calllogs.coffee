define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Calllog       = require 'models/calllog'


  ###*
   * Class representing a collection of {Calllog}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Calllogs extends Collection
    _.extend @prototype, Chaplin.EventBroker

    model:  Calllog


    ###*
     * Query all {Calllog} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Calllogs}
    ###
    @forDump: (dumpid) ->
    	return new Calllogs url: "#{Chaplin.mediator.urlprefix}/calllogs/#{dumpid}/all"
