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
      info:
        top: @findTopContacts()

    findTopContacts: ->
      sum = 0
      contacts = @model.get('contacts').chain()
        .map (contact) ->
          minutesOut = minutesIn = messagesOut = messagesIn = 0
          contact.get('phonenumbers').each (phonenumber) ->
            phonenumber.get('calllogs').each (calllog) ->
              switch calllog.get('direction')
                when 'OUTGOING' then minutesOut += calllog.get('duration')
                when 'INCOMING' then minutesIn += calllog.get('duration')

          contact.get('phonenumbers').each (phonenumber) ->
            phonenumber.get('messages').each (message) ->
              switch message.get('direction')
                when 'OUTGOING' then messagesOut++
                when 'INCOMING' then messagesIn++

          score = (messagesIn + messagesOut) * TopView.MESSAGES_MULTI + (minutesOut + minutesIn) * TopView.MINUTES_MULTI
          sum += score

          contact: contact.attributes
          score: score
          minutes:
            out: (minutesOut / 60).toFixed(2)
            in:  (minutesIn / 60).toFixed(2)
          messages: 
            out: messagesOut
            in:  messagesIn

        .each((contact) -> contact.percent = "#{contact.score / sum * 100}")
        .sortBy('score')
        .value()

      contacts.reverse().splice 0, 10

