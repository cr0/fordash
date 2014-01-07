define (require) ->
  'use strict'

  View              = require 'views/base/view'
  ContactBubbleView = require 'views/contact/contactbubble-view'
  TopView           = require 'views/contact/top-view'
  
  Template          = require 'templates/contact/index'


  class OverviewView extends View
    template:   Template
    className:  'graph'
    regions:
      'contacts': 'div.contacts'
      'top':      'div.top'

    attach: ->
      super

      @subview 'contacts', new ContactBubbleView model: @model, region: 'contacts'
      @subview 'top', new TopView model: @model, region: 'top'