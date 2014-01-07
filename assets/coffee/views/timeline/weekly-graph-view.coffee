define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class WeeklyGraphView extends View
    @DAY_NAMES: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']

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
        @chart = nv.models.multiBarChart()
          .margin
            left: 40
          .x((d) -> d.label)
          .y((d) -> d.value)
          .color(d3.scale.category10().range())

        @chart.xAxis
          .axisLabel('Wochentag')
          .tickFormat (d) =>
            WeeklyGraphView.DAY_NAMES[d]

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
          label: parseInt weekday, 10
          value: calls.length
        .sortBy('label')
        .value()

      smsmms = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['SMS', 'MMS'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-w')(new Date(message.get('date')))
        .map (calls, weekday) ->
          label: parseInt weekday, 10
          value: calls.length
        .sortBy('label')
        .value()

      wa = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD'] and message.get('direction') in direction
        .groupBy (message) ->
          d3.time.format('%-w')(new Date(message.get('date')))
        .map (calls, weekday) ->
          label: parseInt weekday, 10
          value: calls.length
        .sortBy('label')
        .value()

      addMissingWeekdays = (array) ->
        days = [0..6]

        _.each array, (el) -> 
          pos = -1
          for day in days
            pos++
            break if day is el.label
          days[pos] = null

        _.each _.without(days, null), (day) ->
          array.push 
            label: day
            value: 0

        _.sortBy array, 'label'

      [
        key: 'Telefonate (Minuten)'
        values: addMissingWeekdays calls
      ,
        key: 'Nachrichten (SMS/MMS)'
        values: addMissingWeekdays smsmms
      ,
        key: 'Nachrichten (Whatsapp)'
        values: addMissingWeekdays wa
      ]