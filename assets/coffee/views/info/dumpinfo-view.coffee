define (require) ->
  'use strict'

  View      = require 'views/base/view'

  Phone     = require 'models/phone'
  
  Template  = require 'templates/dumpinfo'


  class MessageView extends View
    template:   Template
    className:  'graph'

    render: ->
      if @model.get('phone') is null then @model.set 'phone', new Phone()
      super
