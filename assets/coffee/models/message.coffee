define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Message extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/messages/id/"

    defaults:
      body:   '<UNKNOWN_BODY>'
      direction:  '<UNKNOWN_DIRECTION>'
      read:   no
      type:   '<UNKNOWN_TYPE>'
      date:   '<UNKNOWN_DATE>'

    mapping:
      'messagetype':  'direction'
      'messageMedium':'type'
      'body':         'text'

