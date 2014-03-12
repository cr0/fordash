define (require) ->
  'use strict'

  require 'backbone.stickit'

  Chaplin       = require 'chaplin'


  ###*
   * A base {Chaplin.View} class
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class View extends Chaplin.View
    _.extend @prototype, Chaplin.EventBroker
    containerMethod: 'append'

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
