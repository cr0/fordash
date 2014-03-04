define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Browserhistory= require 'models/browserhistory'


  ###*
   * Class representing a collection of {Browserhistory}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Browserhistories extends Collection
    _.extend @prototype, Chaplin.EventBroker

    model:  Browserhistory


    ###
     * Query all {Browserhistory} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Browserhistories}
    ###
    @forDump: (dumpid) ->
    	return new Browserhistories url: "browserhistory/#{dumpid}/all"
