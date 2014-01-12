define (require) ->
  'use strict'

  View              = require 'views/base/view'
  DetailsView       = require 'views/forensic/details-view'
  LogView           = require 'views/forensic/log-view'
  WordSearchView    = require 'views/forensic/word-search-view'
  
  Template          = require 'templates/forensic/index'


  class ForensicView extends View
    template:   Template
    className:  'graph'
    regions:
      'details': 'div.details'
      'log':     'div.log'
      'wordsearch': 'div.wordsearch'

    attach: ->
      super

      @subview 'details', new DetailsView model: @model, region: 'details'
      @subview 'log', new LogView model: @model, region: 'log'
      @subview 'wordsearch', new WordSearchView model: @model, region: 'wordsearch'