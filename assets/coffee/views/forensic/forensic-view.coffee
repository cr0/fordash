define (require) ->
  'use strict'

  View              = require 'views/base/view'
  DetailsView       = require 'views/forensic/details-view'
  LogView           = require 'views/forensic/log-view'
  
  Template          = require 'templates/forensic/index'


  class ForensicView extends View
    template:   Template
    className:  'graph'
    regions:
      'details': 'div.details'
      'log':     'div.log'

    attach: ->
      super

      @subview 'details', new DetailsView model: @model, region: 'details'
      @subview 'log', new LogView model: @model, region: 'log'