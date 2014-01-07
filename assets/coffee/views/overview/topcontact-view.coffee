define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/overview/topcontact'


  class TopcontactView extends View
    @MESSAGES_MULTI:  0.15
    @MINUTES_MULTI:   0.5

    template:         Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()

    calculatedAttributes: ->
      topcontact = @findTopContact()

      info:
        topcontact: topcontact

    findTopContact: ->
      minutes = 0
      messages = 0
      contact = null

      @model.get('contacts').each (currentContact) ->
        currentMinutes = currentContact.get('phonenumbers').reduce (memo, phonenumber) ->
          memo + phonenumber.get('calllogs').reduce (memo, calllog) ->
            memo + calllog.get('duration')
          , 0
        , 0

        currentMessages = currentContact.get('phonenumbers').reduce (memo, phonenumber) ->
          memo + phonenumber.get('messages').length
        , 0

        #console.debug "current contact", currentContact, ": minutes #{currentMinutes} messages #{currentMessages}"

        if currentMessages * TopcontactView.MESSAGES_MULTI + currentMinutes * TopcontactView.MINUTES_MULTI > minutes + messages
          minutes = currentMinutes
          messages = currentMessages
          contact = currentContact
          #console.debug "new top contact", currentContact

      calls = contact.getCalls()
      messages = contact.getMessages()

      {
        calls:  
          number: calls.length
          minutes: (minutes / 60).toFixed(2)
          average: (minutes / calls.length / 60).toFixed(2)
        messages: messages.countBy (message) ->
          if message.get('direction') is 'OUTGOING' then 'sent' else 'received'
        contact: contact?.attributes
      }

