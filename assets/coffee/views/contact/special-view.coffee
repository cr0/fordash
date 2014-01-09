define (require) ->
  'use strict'

  View      = require 'views/base/view'
  
  Template  = require 'templates/contact/special'


  class SpecialView extends View
    @SKIP_INTERNALS:  [9999]
    @ONLY_MESSAGES:   'nur per Nachrichten kommuniziert wurde'
    @ONETIME:         'nur einmal Kommunikation stattgefunden hat*'
    @LONGESTCALL:     _.template 'es mit <%= duration %> Minuten das längste Telefonat war'

    template:         Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()

    calculatedAttributes: ->
      specials: @findSpecialContacts()

    findSpecialContacts: ->
      contacts = @model.get('contacts')

      onlymessages = contacts.chain()
        .filter (contact) ->
          if contact.get('internalPhoneId') in SpecialView.SKIP_INTERNALS then return no
          return not contact.getCalls().reduce (memo, call) ->
            memo + call.get('duration')
          , 0
        .map (contact) ->
          contact: contact.attributes, reason: SpecialView.ONLY_MESSAGES, numMessages: contact.getMessages().length
        .max('numMessages')
        .value()

      onetime = contacts.chain()
        .filter (contact) ->
          if contact.get('internalPhoneId') in SpecialView.SKIP_INTERNALS then return no
          if contact.getCalls().length is 1 then return no
          if contact.getMessages().length is 1 then return no
        .map (contact) ->
          contact: contact.attributes, reason: SpecialView.ONETIME
        .sample(3)
        .value()

      longestcall = @model.getCalls().chain()
        .map (call) ->
          contact = call.get('phonenumber').get('contact')
          duration = call.get('duration')

          contact: contact.attributes, reason: SpecialView.LONGESTCALL(duration: (duration / 60).toFixed(2)), duration: duration
        .max('duration')
        .value()

      _.flatten [onlymessages, onetime, longestcall]





