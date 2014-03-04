define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Dump          = require 'models/dump'


  ###*
   * Class representing a collection of {Dump}s. This collection is unique within the app.
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Dumps extends Collection
    _.extend @prototype, Chaplin.EventBroker

    url:    "#{Chaplin.mediator.urlprefix}/dumps/all"
    model:  Dump
