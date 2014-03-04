define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'


  ###*
   * Class representing a {Phone}. A phone is attached to a {Dump} providing some metadata.
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Phone extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "phones/id/"

    defaults:
      brand: '<UNKNOWN_BRAND>'
      model: '<UNKNOWN_MODEL>'

