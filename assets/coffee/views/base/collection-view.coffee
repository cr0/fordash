define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'
  View          = require 'views/base/view'


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
