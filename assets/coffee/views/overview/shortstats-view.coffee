define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/overview/shortstats'


  class ShortstatsView extends View
    template:   Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()

    calculatedAttributes: ->
      info:
        contacts: 
          total: @model.get('contacts').length
        messages:
          total: @model.getMessages().length
        calllogs:
          total: @_getTotalMinutes()


    _getTotalMinutes: ->
      seconds = @model.getCalls().reduce (memo, calllog) ->
            memo + calllog.get('duration')
          ,0
        , 0
      , 0 

      (seconds / 60).toFixed(2)
