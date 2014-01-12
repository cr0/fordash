define (require) ->
  'use strict'

  View              = require 'views/base/view'
  ContactBubbleView = require 'views/contact/contactbubble-view'
  TopView           = require 'views/contact/top-view'
  SpecialView       = require 'views/contact/special-view'
  DetailsView       = require 'views/contact/details-view'
  LogView           = require 'views/contact/log-view'
  
  Template          = require 'templates/contact/index'


  class OverviewView extends View
    template:   Template
    className:  'graph'
    regions:
      'details':    'div.details'
      'log':        'div.log'
      'special':    'div.special'
      'contacts':   'div.contacts'
      'top':        'div.top'

    attach: ->
      super

      @subview 'contacts', new ContactBubbleView model: @model, region: 'contacts'
      @subview 'top', new TopView model: @model, region: 'top'
      @subview 'special', new SpecialView model: @model, region: 'special'
      @subview 'details', new DetailsView model: @model, region: 'details'
      @subview 'log', new LogView model: @model, region: 'log'