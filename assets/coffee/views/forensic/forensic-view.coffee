define (require) ->
  'use strict'

  View              = require 'views/base/view'
  WordSearchView    = require 'views/forensic/word-search-view'
  
  Template          = require 'templates/forensic/index'


  class ForensicView extends View
    template:   Template
    className:  'graph'
    regions:
      'wordsearch': 'div.wordsearch'

    attach: ->
      super

      @subview 'wordsearch', new WordSearchView model: @model, region: 'wordsearch'