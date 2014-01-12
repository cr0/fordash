define (require) ->
  'use strict'

  Chaplin   = require 'chaplin'
  d3        = require 'd3'

  View      = require 'views/base/view'
  
  Template  = require 'templates/forensic/word-search-result'


  class WordSearchResultView extends View
    @DATE_FORMAT:     d3.time.format('%Y-%m-%d %H:%M:%S')

    template:   Template
    autoRender: no

    getTemplateData: ->
      dumpId = Chaplin.mediator.dumpid

      messagesByAuthor = @model.chain()
        .map (message) =>
          contact = message.get('phonenumber').get('contact')
          dir = message.get('direction') is 'INCOMING'
          type = switch message.get('type') 
            when 'WHATSAPPTEXT'
              if dir then 'MSG_INCOMING_WA_TEXT' else 'MSG_OUTGOING_WA_TEXT'
            when 'MMS'
              if dir then 'MSG_INCOMING_MMS' else 'MSG_OUTGOING_MMS'
            when 'SMS'
              if dir then 'MSG_INCOMING_SMS' else 'MSG_OUTGOING_SMS'

          contact:  contact.get('name')
          date:     WordSearchResultView.DATE_FORMAT new Date(message.get('date')) 
          text:     message.get('text').replace(/\n?\r\n/g, '<br />' )
          url:      "/dashboard/#{dumpId}/contact/#{contact.get('id')}#msg:#{message.id}"
          type:     type
        .groupBy (message) ->
          message.contact
        .value()

      messagesWithAuthor = _.chain(messagesByAuthor)
        .map (messages, author) ->
          author:   author 
          messages: messages
        .sortBy (pair) ->
          pair.author
        .value()

      console.debug "Results for query:", results: messagesWithAuthor

      results: messagesWithAuthor
