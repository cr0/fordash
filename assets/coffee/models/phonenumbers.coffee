define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Phonenumber   = require 'models/phonenumber'


  ###*
   * Class representing a collection of {Phonenumber}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Phonenumbers extends Collection
    _.extend @prototype, Chaplin.EventBroker

    #url:    "#{Chaplin.mediator.urlprefix}/number/#{Chaplin.mediator.dumpid}/all"
    model:  Phonenumber


    ###*
     * Query all {Phonenumber} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Phonenumbers}
    ###
    @forDump: (dumpid) ->
    	return new Phonenumbers url: "number/#{dumpid}/all"
