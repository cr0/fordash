define (require) ->
  'use strict'

  View      = require 'views/base/view'

  Template  = require 'templates/contact/log'


  class LogView extends View
    @CALL_SENT_LINE:     _.template("Telefonat (Dauer: <%= duration %> Minuten)")
    @CALL_RECEIVED_LINE: _.template("Telefonat (Dauer: <%= duration %> Minuten)")
    @CALL_MISSED_LINE:   _.template("Verpasster Anruf")

    template:         Template
    contact:          null

    initialize: ->
      @subscribeEvent 'contact:change', (contact) =>
        console.debug "contact changed to", contact
        @contact = contact
        @render()

      @delegate 'click', 'a[data-timeline]', (e) =>
        e.preventDefault()
        $tel = $(e.target)

        @$el.find('a[data-timeline]').removeClass('active')
        $tel.addClass('active')

        type = $tel.data('timeline')
        if type is 'all' then return @$el.find('ul.lines li').show()

        showTypes = switch type
          when 'phone' then ['CALL_INCOMING', 'CALL_OUTGOING', 'CALL_MISSED']
          when 'message' then ['MSG_INCOMING_MMS', 'MSG_OUTGOING_MMS', 'MSG_INCOMING_SMS', 'MSG_OUTGOING_SMS']
          when 'whatsapp' then ['MSG_INCOMING_WA_TEXT', 'MSG_OUTGOING_WA_TEXT', 'MSG_INCOMING_WA_PIC', 'MSG_OUTGOING_WA_PIC', 'MSG_INCOMING_WA_VIDEO', 'MSG_OUTGOING_WA_VIDEO', 'MSG_OUTGOING_WA_AUDIO', 'MSG_INCOMING_WA_AUDIO']

        @$el.find('ul.lines li').each (idx, el) =>
          $el = $(el)
          if $el.data('type') in showTypes then $el.show()
          else $el.hide()


    getTemplateData: -> $.extend @model.attributes, @calculatedAttributes()


    calculatedAttributes: ->
      response = forensic: {}
      if @contact
        response.forensic.log =
          name:  @contact.get('name')
          lines: @_createLogFile()

      response


    _createLogFile: ->
      calls = @contact.getCalls().map (call) ->

        vars = duration: (call.get('duration') / 60).toFixed(2)

        message = switch call.get('direction')
          when 'INCOMING'
            if call.get('duration') > 0 then LogView.CALL_RECEIVED_LINE(vars) else LogView.CALL_MISSED_LINE(vars)
          when 'OUTGOING' then LogView.CALL_SENT_LINE(vars)

        type = switch call.get('direction')
          when 'INCOMING'
            if call.get('duration') > 0 then 'CALL_INCOMING' else 'CALL_MISSED'
          when 'OUTGOING' then 'CALL_OUTGOING'

        contactName:    call.get('phonenumber').get('contact').get('name')
        type:           type
        message:        message
        formatted_date: call.get('formatted_date')
        date:           call.get('date')


      messages = @contact.getMessages().map (message) ->

        dir = message.get('direction') is 'INCOMING'

        text = switch message.get('type')
          when 'WHATSAPPTEXT' then message.get('text')
          when 'SMS' then message.get('text')
          else "DATA #{message.get('text')}"

        type = switch message.get('type')
          when 'WHATSAPPTEXT'
            if dir then 'MSG_INCOMING_WA_TEXT' else 'MSG_OUTGOING_WA_TEXT'
          when 'WHATSAPPPIC'
            if dir then 'MSG_INCOMING_WA_PIC' else 'MSG_OUTGOING_WA_PIC'
          when 'WHATSAPPVID'
            if dir then 'MSG_INCOMING_WA_VIDEO' else 'MSG_OUTGOING_WA_VIDEO'
          when 'WHATSAPPAUD'
            if dir then 'MSG_INCOMING_WA_AUDIO' else 'MSG_OUTGOING_WA_AUDIO'
          when 'MMS'
            if dir then 'MSG_INCOMING_MMS' else 'MSG_OUTGOING_MMS'
          when 'SMS'
            if dir then 'MSG_INCOMING_SMS' else 'MSG_OUTGOING_SMS'

        contactName:    message.get('phonenumber').get('contact').get('name')
        type:           type
        message:        text.replace(/\n?\r\n/g, '<br />' )
        formatted_date: message.get('formatted_date')
        date:           message.get('date')


      _.chain([calls, messages])
        .flatten()
        .sortBy('date')
        .reverse()
        .value()
