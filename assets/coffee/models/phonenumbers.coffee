define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Phonenumber   = require 'models/phonenumber'


  class Phonenumbers extends Collection
    _.extend @prototype, Chaplin.EventBroker

    #url:    "#{Chaplin.mediator.urlprefix}/number/#{Chaplin.mediator.dumpid}/all"
    model:  Phonenumber

    @forDump: (dumpid) ->
    	return new Phonenumbers url: "#{Chaplin.mediator.urlprefix}/number/#{dumpid}/all"