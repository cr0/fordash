define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Phone extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/phones/id/"

    defaults:
      brand: '<UNKNOWN_BRAND>'
      model: '<UNKNOWN_MODEL>'

