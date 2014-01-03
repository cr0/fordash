define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/graph/message'


  class MessageView extends View
    template:   Template
    className:	'graph'

    render: ->
      console.log "rendering message"
      super