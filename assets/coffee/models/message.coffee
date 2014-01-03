define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Message extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/messages/id/"

    defaults:
      body:   '<UNKNOWN_BODY>'
      read:   no
      type:   '<UNKNOWN_TYPE>'
      medium: '<UNKNOWN_MEDIUM>'
      date:   '<UNKNOWN_DATE>'

