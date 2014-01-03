define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Contact       = require 'models/contact'


  class Contacts extends Collection
    _.extend @prototype, Chaplin.EventBroker

    #url:    "#{Chaplin.mediator.urlprefix}/contact/#{Chaplin.mediator.dumpid}/all"
    model:  Contact

    @forDump: (dumpid) ->
    	return new Contacts url: "#{Chaplin.mediator.urlprefix}/contact/#{dumpid}/all"
