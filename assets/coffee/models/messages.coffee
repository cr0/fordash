define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Message       = require 'models/message'


  ###*
   * Class representing a collection of {Message}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Messages extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "messages/#{Chaplin.mediator.dumpid}/all"
    model:  Message


    ###*
     * Query all {Message} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Messages}
    ###
    @forDump: (dumpid) ->
    	return new Messages url: "messages/#{dumpid}/all"


    ###*
     * Query all {Message} entries for a specific {Dump} which contain a queried word
     *
     * @param  {String} dumpid
     * @param {String} word The word which all {Message}s have to contain
     * @return {Messages}
    ###
    @forDumpAndWord: (dumpid, word) ->
      return new Messages url: "messages/#{dumpid}/sequence/#{word}"
