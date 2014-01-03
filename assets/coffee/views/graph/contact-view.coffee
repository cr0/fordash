define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/graph/contact'


  class ContactView extends View
    template:   Template
    className:	'graph'

    render: ->
      console.log "rendering contact"
      super