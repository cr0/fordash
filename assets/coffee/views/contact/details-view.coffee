define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'
  
  Template  = require 'templates/contact/details'


  class LogView extends View
    template:         Template
    contact:          null

    initialize: ->
      @subscribeEvent 'contact:change', (contact) => 
        console.debug "contact changed to", contact
        @contact = contact
        @render()


    getTemplateData: -> $.extend @model.toJSON(), @calculatedAttributes()


    render: ->
      return super unless @contact

      nv.addGraph () => 
        chart = nv.models.bulletChart()
          .color(['#fcb941', 'gray'])
          .margin
            left: 70
            right: 0
          .height(50)

        d3.select(@$el.find('div.average.phone')[0])
          .append('svg')
          .datum(@minutesChartData())
          .transition().duration(1000)
          .call(chart)

        chart


      nv.addGraph () => 
        chart = nv.models.bulletChart()
          .color(['#fcb941', 'gray'])
          .margin
            left: 70
            right: 0
          .height(50)

        d3.select(@$el.find('div.average.messages')[0])
          .append('svg')
          .datum(@messagesChartData())
          .transition().duration(1000)
          .call(chart)

        chart


      super


    calculatedAttributes: ->
      response = forensic: {}
      if @contact
        response.forensic.details =  
          contact:  $.extend @contact.toJSON(), phonenumbers: @contact.get('phonenumbers').map (number) -> number.toJSON()
          minutes:  @minutesData()
          messages: @messagesData()

      response


    minutesData: ->
      minutesIn = minutesOut = 0

      @contact.getCalls().each (call) ->
        switch call.get('direction')
          when 'OUTGOING' then minutesOut += call.get('duration')
          when 'INCOMING' then minutesIn += call.get('duration')

      in: (minutesIn / 60).toFixed(2), out: (minutesOut / 60).toFixed(2)


    messagesData: ->
      @contact.getMessages().countBy (message) -> if message.get('direction') is 'INCOMING' then 'in' else 'out'


    minutesChartData: ->
      overallMinutes = @model.getCalls().reduce (memo, call) ->
        memo + call.get('duration')
      , 0
      overallMinutes = (overallMinutes / 60).toFixed()

      userMinutes = @contact.getCalls().reduce (memo, call) ->
        memo + call.get('duration')
      , 0
      userMinutes = (userMinutes / 60).toFixed()

      average = (overallMinutes / @model.get('contacts').length).toFixed()

      title:    'Telefonate'
      subtitle: 'in Minuten'
      ranges:   [ overallMinutes ]
      measures: [ average ]
      markers:  [ userMinutes ]


    messagesChartData: ->
      overallMessages = @model.getMessages().length
      userMessages = @contact.getMessages().length
      average = (overallMessages / @model.get('contacts').length).toFixed()

      title:    'Nachrichten'
      ranges:   [ overallMessages ]
      measures: [ average ]
      markers:  [ userMessages ]