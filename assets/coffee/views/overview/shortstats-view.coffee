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
          total: @_getTotalMessages()
        calllogs:
          total: @_getTotalMinutes()

    _getTotalMessages: ->
      @model.get('contacts').reduce (memo, contact) ->
        memo + contact.get('phonenumbers').reduce (memo, phonenumber) -> 
          memo + phonenumber.get('messages').length
        , 0
      , 0 

    _getTotalMinutes: ->
      seconds = @model.get('contacts').reduce (memo, contact) ->
        memo + contact.get('phonenumbers').reduce (memo, phonenumber) -> 
          memo + phonenumber.get('calllogs').reduce (memo, calllog) ->
            memo + calllog.get('duration')
          ,0
        , 0
      , 0 

      (seconds / 60).toFixed(2)
