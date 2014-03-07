define (require) ->
  'use strict'

  DumpView          = require 'views/base/dump-view'
  WordSearchView    = require 'views/forensic/word-search-view'
  TimestampView     = require 'views/forensic/timestamp-view'
  WebsiteView       = require 'views/forensic/website-view'
  PictureMap        = require 'views/forensic/picturemap-view'
  PictureList       = require 'views/forensic/picturelist-view'

  Template          = require 'templates/forensic/index'


  class ForensicView extends DumpView
    template:   Template
    className:  'graph'
    regions:
      'wordsearch': 'div.wordsearch'
      'timestamp': 'div.timestamp'
      'websites': 'div.websites'
      'pictures': 'div.pictures'


    initialize: ->
      super

      @delegate 'click', 'i.map', => @subview 'pictures', new PictureMap model: @model, region: 'pictures'
      @delegate 'click', 'i.list', => @subview 'pictures', new PictureList model: @model, region: 'pictures'


    attach: ->
      super

      @subview 'wordsearch', new WordSearchView model: @model, region: 'wordsearch'
      @subview 'timestamp', new TimestampView model: @model, region: 'timestamp'
      @subview 'websites', new WebsiteView model: @model, region: 'websites'
      @subview 'pictures', new PictureMap model: @model, region: 'pictures'
      #@subview 'pictures', new PictureList model: @model, region: 'pictures'
