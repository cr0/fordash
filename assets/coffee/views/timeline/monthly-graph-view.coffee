define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class MonthlyGraphView extends View
    @MONTH_NAMES: [null, 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober',
      'November', 'Dezember']

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
        @chart = nv.models.lineChart()
        # @chart = nv.models.stackedAreaChart()
          .margin
            left: 40
          .x((d) -> d.label)
          .y((d) -> d.value)
          .xDomain([1,12])
          .color(['#2C82C9','#EEE657', '#FCB941', '#FC6042', '#fff'])

        @chart.xAxis
          .scale(1)
          .tickValues([1..12])
          .axisLabel('Monat')
          .tickFormat (d) =>
            MonthlyGraphView.MONTH_NAMES[d]

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
          d3.time.format('%-m')(new Date(calllog.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy('label')
        .value()

      smsmms = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['SMS', 'MMS'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-m')(new Date(message.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy('label')
        .value()

      wa = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-m')(new Date(message.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy('label')
        .value()

      calendars = @model.get('calendars').chain()
        .filter (calendar) =>
          d3.time.format('%Y')(new Date(calendar.get('start'))) is "#{@year}"
        .groupBy (calendar) ->
          d3.time.format('%-m')(new Date(calendar.get('start')))
        .map (calendars, month) ->
          label: parseInt month, 10
          value: calendars.length
        .sortBy('label')
        .value()

      browserhistories = @model.get('browserhistories').chain()
        .filter (browserhistory) =>
          d3.time.format('%Y')(new Date(browserhistory.get('start'))) is "#{@year}"
        .groupBy (browserhistory) ->
          d3.time.format('%-m')(new Date(browserhistory.get('start')))
        .map (browserhistories, month) ->
          label: parseInt month, 10
          value: browserhistories.length
        .sortBy('label')
        .value()

      addMissingMonths = (array) ->
        months = [1..12]

        _.each array, (el) -> 
          pos = -1
          for month in months
            pos++
            break if month is el.label
          months[pos] = null

        _.each _.without(months, null), (month) ->
          array.push 
            label: month
            value: 0

        _.sortBy array, 'label'

      [
        key: 'Telefonate (Minuten)'
        values: addMissingMonths calls
      ,
        key: 'Nachrichten (SMS/MMS)'
        values: addMissingMonths smsmms
      ,
        key: 'Nachrichten (Whatsapp)'
        values: addMissingMonths wa
      ,
        key: 'Termine'
        values: addMissingMonths calendars
      ,
        key: 'Webseiten'
        values: addMissingMonths browserhistories
      ]