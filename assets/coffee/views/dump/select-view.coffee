define (require) ->
  'use strict'

  CollectionView  = require 'views/base/collection-view'
  DumpItemView    = require 'views/dump/item-view'
  
  Template        = require 'templates/dump/select'


  class DumpSelectView extends CollectionView
    template:       Template
    className:      'dumps'
    itemView:       DumpItemView
    listSelector:   'ul.dumps'

    renderAllItems: ->
      console.debug "rendering collection", @collection
      super