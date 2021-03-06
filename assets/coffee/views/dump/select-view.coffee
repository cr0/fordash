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

    initialize: ->
      super
      @subscribeEvent 'refresh:dumps', => @collection.fetch().fail (e) =>
        @publishEvent '!error', new Error "An error occurred while requesting the dumps from the server"


    renderAllItems: ->
      console.debug "rendering collection", @collection
      super
