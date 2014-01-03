define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Dump          = require 'models/dump'


  class Dumps extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/dumps/all"
    model:  Dump