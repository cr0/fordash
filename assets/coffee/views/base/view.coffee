define (require) ->
  'use strict'

  require 'backbone.stickit'

  Chaplin       = require 'chaplin'


  class View extends Chaplin.View
    autoRender: true
    getTemplateFunction: -> @template
    
    render: ->
      super
      @stickit() if @model
      @trigger 'rendered'

    dispose: ->
      window.setTimeout () =>
        super
        @unstickit() if @model
      , 0

    highlight: ($el, val, options) ->
      $el.fadeOut 500, () -> $(this).fadeIn(500)
