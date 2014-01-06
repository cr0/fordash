define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class WeeklyGraphView extends View
    @DAY_NAMES: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']

    attach: ->
      super
      nv.addGraph () =>
        chart = nv.models.multiBarChart()
          .margin
            left: 40
          .x((d) -> d.label)
          .y((d) -> d.value)

        chart.xAxis
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
          .call(chart)

        nv.utils.windowResize chart.update

        chart

    data: ->
      calls = @model.getCalls().chain()
        .filter (calllog) ->
          d3.time.format('%Y')(new Date(calllog.get('date'))) is '2013'
        .groupBy (calllog) ->
          d3.time.format('%-w')(new Date(calllog.get('date')))
        .map (calls, weekday) ->
          label: parseInt weekday, 10
          value: calls.length
        .sortBy('label')
        .value()

      smsmms = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('messageMedium') in ['SMS', 'MMS']
        .groupBy (message) ->
          d3.time.format('%-w')(new Date(message.get('date')))
        .map (calls, weekday) ->
          label: parseInt weekday, 10
          value: calls.length
        .sortBy('label')
        .value()

      wa = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('messageMedium') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD']
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