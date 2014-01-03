define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Picture extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/pictures/id/"

    defaults:
      duration:   -1
      name:   '<UNKNOWN_NAME>'
      type:   '<UNKNOWN_TYPE>'

