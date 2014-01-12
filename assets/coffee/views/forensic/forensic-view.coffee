define (require) ->
  'use strict'

  View              = require 'views/base/view'
  WordSearchView    = require 'views/forensic/word-search-view'
  TimestampView     = require 'views/forensic/timestamp-view'
  
  Template          = require 'templates/forensic/index'


  class ForensicView extends View
    template:   Template
    className:  'graph'
    regions:
      'wordsearch': 'div.wordsearch'
      'timestamp': 'div.timestamp'

    attach: ->
      super

      @subview 'wordsearch', new WordSearchView model: @model, region: 'wordsearch'
      @subview 'timestamp', new TimestampView model: @model, region: 'timestamp'