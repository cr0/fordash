define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Picture       = require 'models/picture'


  ###*
   * Class representing a collection of {Picture}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Pictures extends Collection
    _.extend @prototype, Chaplin.EventBroker

    model:  Picture


    ###*
     * Query all {Picture} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Pictures}
    ###
    @forDump: (dumpid) ->
    	return new Pictures url: "media/#{dumpid}/all"
