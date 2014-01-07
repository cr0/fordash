define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/contact/top'


  class TopView extends View
    @MESSAGES_MULTI:  0.15
    @MINUTES_MULTI:   0.5

    template:         Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()

    calculatedAttributes: ->
      console.log @findTopContacts()
      info:
        top: @findTopContacts()

    findTopContacts: ->
      sum = 0
      contacts = @model.get('contacts').chain()
        .map (contact) ->
          minutes = contact.get('phonenumbers').reduce (memo, phonenumber) ->
            memo + phonenumber.get('calllogs').reduce (memo, calllog) ->
              memo + calllog.get('duration')
            , 0
          , 0

          messages = contact.get('phonenumbers').reduce (memo, phonenumber) ->
            memo + phonenumber.get('messages').length
          , 0

          score = messages * TopView.MESSAGES_MULTI + minutes * TopView.MINUTES_MULTI
          sum += score

          contact: contact.attributes, score: score, minutes: (minutes / 60).toFixed(2), messages: messages

        .each((contact) -> contact.percent = "#{contact.score / sum * 100}")
        .sortBy('score')
        .value()

      contacts.reverse().splice 0, 10

