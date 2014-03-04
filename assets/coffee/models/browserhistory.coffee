define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'


  ###*
   * Class representing a {Browserhistory} event like a visited website
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Browserhistory extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/browserhistory/id/"

    defaults:
      visit:   -1
      title:  '<UNKNOWN_TITLE>'
      date:   '<UNKNOWN_DATE>'
      url:    '<UNKNOWN_URL>'
      bookmark: no

