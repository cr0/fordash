define (require) ->
  'use strict'

  DumpView  = require 'views/base/dump-view'

  Phone     = require 'models/phone'

  Template  = require 'templates/dumpinfo'


  class DumpInfoView extends DumpView
    template:   Template
    className:  'graph'

    render: ->
      if @model.get('phone') is null then @model.set 'phone', new Phone()
      super
