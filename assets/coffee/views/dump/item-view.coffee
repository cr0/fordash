define (require) ->
  'use strict'

  View      = require 'views/base/view'

  Phone     = require 'models/phone'
  
  Template  = require 'templates/dump/item'


  class DumpItemView extends View
    template:   Template
    tagName:    'li'
    bindings:
      '.brand':    'phone.brand'
      '.model':    'phone.model'

    render: ->
      if @model.get('phone') is null then @model.set 'phone', new Phone()
      super