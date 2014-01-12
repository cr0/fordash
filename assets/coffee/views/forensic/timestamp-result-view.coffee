define (require) ->
  'use strict'

  Chaplin   = require 'chaplin'
  d3        = require 'd3'

  Calllog   = require 'models/calllog'
  Message   = require 'models/message'

  View      = require 'views/base/view'
  
  Template  = require 'templates/forensic/timestamp-result'


  class TimestampResultView extends View
    @DATE_FORMAT:        d3.time.format('%Y-%m-%d %H:%M:%S')
    @CALL_SENT_LINE:     _.template("Telefonat (Dauer: <%= duration %> Minuten)")
    @CALL_RECEIVED_LINE: _.template("Telefonat (Dauer: <%= duration %> Minuten)")
    @CALL_MISSED_LINE:   _.template("Verpasster Anruf")

    template:   Template


    getTemplateData: ->
      dumpId = Chaplin.mediator.dumpid

      itemByAuthor = @model.chain()
        .map (item) =>
          contact = item.get('phonenumber').get('contact')

          if item instanceof Calllog
            vars = duration: (item.get('duration') / 60).toFixed(2)
            text = switch item.get('direction')
              when 'INCOMING'
                if item.get('duration') > 0 then TimestampResultView.CALL_RECEIVED_LINE(vars) else TimestampResultView.CALL_MISSED_LINE(vars)
              when 'OUTGOING' then TimestampResultView.CALL_SENT_LINE(vars)

            type = switch item.get('direction') 
              when 'INCOMING'
                if item.get('duration') > 0 then 'CALL_INCOMING' else 'CALL_MISSED'
              when 'OUTGOING' then 'CALL_OUTGOING'


          else if item instanceof Message
            dir = item.get('direction') is 'INCOMING'

            text = switch item.get('type')
              when 'WHATSAPPTEXT' then item.get('text')
              when 'SMS' then item.get('text')
              else "DATA #{item.get('text')}"

            type = switch item.get('type') 
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


          else
            type = '<UNKNOWN_TYPE>'
            text = '<UNKNOWN_TYPE>'



          contact:  contact.get('name')
          date:     TimestampResultView.DATE_FORMAT new Date(item.get('date')) 
          text:     text
          url:      "/dashboard/#{dumpId}/contact/#{contact.get('id')}"
          type:     type
        .groupBy (item) ->
          item.contact
        .value()

      itemsWithAuthor = _.chain(itemByAuthor)
        .map (items, author) ->
          author:  author 
          items:   _.sortBy(items, (item) -> item.date).reverse()
        .sortBy (pair) ->
          pair.author
        .value()

      console.debug "Results for timestamp:", results: itemsWithAuthor

      results: itemsWithAuthor
