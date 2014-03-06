define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'
  View          = require 'views/base/view'


  ###*
   * A base {Chaplin.CollectionView} class
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class CollectionView extends Chaplin.CollectionView
    _.extend @prototype, Chaplin.EventBroker

    autoRender: true
    getTemplateFunction: View::getTemplateFunction

    render: ->
      super
      @trigger 'rendered'

    dispose: ->
      window.setTimeout () =>
        super
      , 0
