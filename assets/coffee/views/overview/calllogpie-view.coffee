define (require) ->
  'use strict'

  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class CalllogPieView extends View

    render: ->
      super
      nv.addGraph () =>
        chart = nv.models.pieChart()
          .x((d) -> d.label)
          .y((d) -> d.value)
          .showLabels(yes)
          .showLegend(no)
          .donut(yes)
          .color(d3.scale.category10().range())

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
      incoming = 0
      outgoing = 0

      @model.getCalls().each (calllog) ->
        if calllog.get('direction') is 'OUTGOING' then outgoing++
        else if calllog.get('direction') is 'INCOMING' then incoming++

      [
        label: 'Eingehend'
        value: incoming
      ,
        label: 'Ausgehend'
        value: outgoing
      ]