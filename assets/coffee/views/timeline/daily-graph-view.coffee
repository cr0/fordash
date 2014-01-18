define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class DailyGraphView extends View
    @DAY_NAMES:      ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']
    @HOUR_INTERVALS: ['00-02', '02-04', '04-06', '06-08', '08-10', '10-12', '12-14', '14-16', '16-18',
                      '18-20', '20-22', '22-00']

    year:     d3.time.format('%Y')(new Date())
    direction:'both'

    initialize: ->
      @subscribeEvent 'graph:yearchange', (year) => 
        @year = year
        @update()

      @subscribeEvent 'graph:directionchange', (direction) => 
        @direction = direction
        @update()

    attach: ->
      super
      nv.addGraph () =>
        @chart = nv.models.scatterChart()
          .margin
            left: 80
          .color(['#2C82C9','#EEE657', '#FCB941', '#FC6042', '#fff'])

        @chart.xAxis
          .axisLabel('Intervall')
          .tickValues([0..12])
          .tickFormat (d) =>
            DailyGraphView.HOUR_INTERVALS[d]

        @chart.yAxis
          .axisLabel('Wochentag')
          .ticks(7)
          .tickFormat (d) =>
            DailyGraphView.DAY_NAMES[d]

        d3
          .select(@$el[0])
          .append("svg")
          .attr("width", "100%")
          .attr("height", "100%")
          .datum(@data())
          .transition().duration(1200)
          .call(@chart)

        nv.utils.windowResize @chart.update

        @chart

    update: ->
      d3
        .select(@$el[0])
        .datum(@data())
        .transition().duration(1200)
        .call(@chart)

    data: ->
      direction = switch @direction
        when 'both' then ['INCOMING', 'OUTGOING']
        when 'in' then ['INCOMING']
        when 'out' then ['OUTGOING']

      calls = @model.getCalls().chain()
        .filter (calllog) =>
          d3.time.format('%Y')(new Date(calllog.get('date'))) is "#{@year}" and calllog.get('direction') in direction
        .groupBy (calllog) ->
          d3.time.format('%-w')(new Date(calllog.get('date')))
        .map (calls, weekday) ->
          callsByTwoHours = _.groupBy calls, (call) ->
            Math.round(d3.time.format('%-H')(new Date(call.get('date'))) / 2)

          _.map callsByTwoHours, (calls, interval) ->
            x:    _.parseInt interval - 1
            y:    _.parseInt weekday
            size: calls.length
        .flatten()
        .value()      
        
      smsmms = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['SMS', 'MMS'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-w')(new Date(message.get('date')))
        .map (messages, weekday) ->
          messagesByTwoHours = _.groupBy messages, (message) ->
            Math.round(d3.time.format('%-H')(new Date(message.get('date'))) / 2)

          _.map messagesByTwoHours, (messages, interval) ->
            x:    _.parseInt interval - 1
            y:    _.parseInt weekday
            size: messages.length
        .flatten()
        .value()     
        
      wa = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-w')(new Date(message.get('date')))
        .map (messages, weekday) ->
          messagesByTwoHours = _.groupBy messages, (message) ->
            Math.round(d3.time.format('%-H')(new Date(message.get('date'))) / 2)

          _.map messagesByTwoHours, (messages, interval) ->
            x:    _.parseInt interval - 1
            y:    _.parseInt weekday
            size: messages.length
        .flatten()
        .value()    
        
      calendars = @model.get('calendars').chain()
        .filter (calendar) =>
          d3.time.format('%Y')(new Date(calendar.get('start'))) is "#{@year}"
        .groupBy (calendar) ->
          d3.time.format('%-w')(new Date(calendar.get('start')))
        .map (calendars, weekday) ->
          calendarsByTwoHours = _.groupBy calendars, (calendar) ->
            Math.round(d3.time.format('%-H')(new Date(calendar.get('start'))) / 2)

          _.map calendarsByTwoHours, (calendars, interval) ->
            x:    _.parseInt interval - 1
            y:    _.parseInt weekday
            size: calendars.length
        .flatten()
        .value()    
        

      browserhistories = @model.get('browserhistories').chain()
        .filter (browser) =>
          d3.time.format('%Y')(new Date(browser.get('date'))) is "#{@year}"
        .groupBy (browser) ->
          d3.time.format('%-w')(new Date(browser.get('date')))
        .map (browsers, weekday) ->
          browsersByTwoHours = _.groupBy browsers, (browser) ->
            Math.round(d3.time.format('%-H')(new Date(browser.get('date'))) / 2)

          _.map browsersByTwoHours, (browsers, interval) ->
            x:    _.parseInt interval - 1
            y:    _.parseInt weekday
            size: browsers.length
        .flatten()
        .value()  

      [
        key: 'Telefonate (Minuten)'
        values: calls
      ,
        key: 'Nachrichten (SMS/MMS)'
        values: smsmms
      ,
        key: 'Nachrichten (Whatsapp)'
        values: wa
      ,
        key: 'Termine'
        values: calendars
      ,
        key: 'Webseiten'
        values: browserhistories
      ]