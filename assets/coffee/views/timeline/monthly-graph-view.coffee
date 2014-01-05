define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class MonthlyGraphView extends View
    @MONTH_NAMES: [null, 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober',
      'November', 'Dezember']

    attach: ->
      super
      console.log @data()
      nv.addGraph () =>
        chart = nv.models.stackedAreaChart()
          .margin
            left: 40
          .x((d) -> d.label)
          .y((d) -> d.value)
          .xDomain([1,12])

        chart.xAxis
          .scale(1)
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
          .call(chart)

        nv.utils.windowResize chart.update

        chart

    data: ->
      calls = @model.getCalls().chain()
        .filter (calllog) ->
          d3.time.format('%Y')(new Date(calllog.get('date'))) is '2013'
        .groupBy (calllog) ->
          d3.time.format('%-m')(new Date(calllog.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy (el) ->
          el.label
        .value()

      smsmms = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('messageMedium') in ['SMS', 'MMS']
        .groupBy (message) ->
          d3.time.format('%-m')(new Date(message.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy (el) ->
          el.label
        .value()

      wa = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('messageMedium') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD']
        .groupBy (message) ->
          d3.time.format('%-m')(new Date(message.get('date')))
        .map (calls, month) ->
          label: parseInt month, 10
          value: calls.length
        .sortBy (el) ->
          el.label
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

        _.sortBy array, (el) -> el.label

      [
        key: 'Telefonate (Minuten)'
        values: addMissingMonths calls
      ,
        key: 'Nachrichten (SMS/MMS)'
        values: addMissingMonths smsmms
      ,
        key: 'Nachrichten (Whatsapp)'
        values: addMissingMonths wa
      ]