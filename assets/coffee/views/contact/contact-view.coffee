define (require) ->
  'use strict'

  View              = require 'views/base/view'
  ContactBubbleView = require 'views/contact/contactbubble-view'
  
  Template          = require 'templates/contact/index'


  class OverviewView extends View
    template:   Template
    className:  'graph'
    regions:
      'contacts': 'div.contacts'

    attach: ->
      super

      @subview 'contacts', new ContactBubbleView model: @model, region: 'contacts'