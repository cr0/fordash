define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Picture       = require 'models/picture'


  class Pictures extends Collection
    _.extend @prototype, Chaplin.EventBroker

    #url:    "#{Chaplin.mediator.urlprefix}/pictures/#{Chaplin.mediator.dumpid}/all"
    model:  Picture

    @forDump: (dumpid) ->
    	return new Pictures url: "#{Chaplin.mediator.urlprefix}/media/#{dumpid}/all"
