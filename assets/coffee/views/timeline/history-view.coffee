define (require) ->
  'use strict'

  _         = require 'underscore'
  links     = require 'links'

  View      = require 'views/base/view'

  Template  = require 'templates/timeline/history'


  class HistoryView extends View
    template:   Template
    events:
      'change select.contacts': (contact...) ->
        console.log "selected contact", contact

    attach: ->
      super

      timeline = new links.Timeline(@$el.find('div.links')[0])
      timeline.draw @_getData(), 
        cluster:    yes
        end:        new Date()
        height:     '450px'


    _getData: ->
      console.debug "Found #{@model.getMessages().length} messages"  

      messages = @model.getMessages().map (message) ->
        direction = if message.get('messagetype') is 'OUTGOING' then 'an' else 'von'

        start:    new Date(message.get('date'))
        content:  "Nachricht #{direction} #{message.get('phonenumber').get('contact').get('name')}"

      calls = @model.getCalls().map (calllog) ->
        direction = if calllog.get('callType') is 'OUTGOING' then 'an' else 'von'
        contactName = calllog.get('phonenumber').get('contact').get('name')
        
        switch calllog.get('duration')
          when 0 then message = "Anruf #{direction} #{contactName}"
          else message = if direction is 'an' then "Unbeantworter Anruf an #{contactName}" else "Verpasster Anruf von #{contactName}"

        start:    new Date(calllog.get('date'))
        end:      new Date(calllog.get('date') + calllog.get('duration') * 1000) if calllog.get('duration') is not 0
        content:  message

      _.union messages, calls