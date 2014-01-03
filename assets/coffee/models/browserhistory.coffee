define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Browserhistory extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/browserhistory/id/"

    defaults:
      visit:   -1
      title:  '<UNKNOWN_TITLE>'
      date:   '<UNKNOWN_DATE>'
      url:    '<UNKNOWN_URL>'
      bookmark: no

