define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Browserhistory= require 'models/browserhistory'


  class Browserhistories extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/browserhistory/#{Chaplin.mediator.dumpid}/all"
    model:  Browserhistory
