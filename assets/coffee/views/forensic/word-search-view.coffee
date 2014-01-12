define (require) ->
  'use strict'


  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  Messages  = require 'models/messages'

  View      = require 'views/base/view'
  LoadView  = require 'views/load-view'
  WordSearchResultView = require 'views/forensic/word-search-result-view'
  
  Template  = require 'templates/forensic/word-search'


  class WordSearchView extends View
    template:         Template

    initialize: ->
      @delegate 'blur', 'input.word', (e) => 
        @search(e.target.value)


    search: (word) ->
      messages = Messages.forDumpAndWord @model.id, word

      @resultView.dispose() if @resultView

      @loadView = new LoadView container: @$el.find('div.messages')
      @resultView =  new WordSearchResultView model: messages, container: @$el.find('div.messages')

      messages.fetch()
        .always =>
          @loadView.dispose()
        .done =>
          @resultView.render()
        .fail => 
          alert "failed to find messages for #{word}"





