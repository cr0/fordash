define (require) ->
  'use strict'

  nv        = require 'nvd3'
  d3        = require 'd3'

  View      = require 'views/base/view'


  class MessagePieView extends View

    render: ->
      super
      nv.addGraph () =>
        chart = nv.models.pieChart()
          .x((d) -> d.label)
          .y((d) -> d.value)
          .showLabels(yes)
          .showLegend(no)
          .donut(yes)

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

      @model.get('contacts').each (contact) ->
        contact.get('phonenumbers').each (phonenumber) ->
          phonenumber.get('messages').each (message) ->
            if message.get('messagetype') is 'OUTGOING' then outgoing++
            else if message.get('messagetype') is 'INCOMING' then incoming++

      [
        label: 'Empfangen'
        value: incoming
      ,
        label: 'Gesendet'
        value: outgoing
      ]