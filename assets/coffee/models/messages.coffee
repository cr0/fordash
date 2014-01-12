define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Message       = require 'models/message'

  class Messages extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/messages/#{Chaplin.mediator.dumpid}/all"
    model:  Message

    @forDump: (dumpid) ->
    	return new Messages url: "#{Chaplin.mediator.urlprefix}/messages/#{dumpid}/all"

    @forDumpAndWord: (dumpid, word) ->
      return new Messages url: "#{Chaplin.mediator.urlprefix}/messages/#{dumpid}/sequence/#{word}"