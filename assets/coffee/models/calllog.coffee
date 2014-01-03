define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Calllog extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/calllogs/id/"

    defaults:
      duration:   -1
      callType:   '<UNKNOWN_CALLTYPE>'
      date:       '<UNKNOWN_DATE>'

