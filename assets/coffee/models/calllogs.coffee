define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Calllog       = require 'models/calllog'


  class Calllogs extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/calllogs/#{Chaplin.mediator.dumpid}/all"
    model:  Calllog

    @forDump: (dumpid) ->
    	return new Calllogs url: "#{Chaplin.mediator.urlprefix}/calllogs/#{dumpid}/all"
