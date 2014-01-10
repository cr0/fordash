define (require) ->
  'use strict'

  _         = require 'underscore'
  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class DailyGraphView extends View
    @DAY_NAMES: ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag']

    attach: ->
      super
      console.log @data()
      nv.addGraph () =>
        chart = nv.models.scatterChart()
          .margin
            left: 40
          .color(['#2C82C9','#EEE657', '#FCB941', '#2CC990', '#FC6042'])

        chart.xAxis
          .axisLabel('Wochentag')
          .tickFormat (d) =>
            DailyGraphView.DAY_NAMES[d]

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
          d3.time.format('%-d')(new Date(calllog.get('date')))
        .map (calls, hour) ->
          _.map calls, (call) ->
            x:    _.parseInt hour
            y:    _.parseInt d3.time.format('%-w')(new Date(call.get('date')))
            size: calls.length
        .flatten()
        .value()

      console.log calls

      [
        key: 'Telefonate (Minuten)'
        values: calls
      ]