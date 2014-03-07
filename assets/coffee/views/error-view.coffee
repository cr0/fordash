define (require) ->
  'use strict'

  View        = require 'views/base/view'

  Template    = require 'templates/error'


  class ErrorView extends View
    template:         Template
    container:        'section.content'
    autoRender:       no
    containerMethod: 'replaceWith'
    className:        'error'


    initialize: ->
      super
      @subscribeEvent '!error', (e) =>
        console.error 'An error occurred', e
        @model = e
        @render()


    getTemplateData: ->
      data =
        name:     @model.name
        code:     if @model.code then @model.code else 500
        message:  @model.message
        stack:    @model.stack
        lineno:   @model.lineNumber
        file:     @model.fileName

      data


    render: ->
      super if @model
