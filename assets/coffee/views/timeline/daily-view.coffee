define (require) ->
  'use strict'

  d3        = require 'd3'

  View      = require 'views/base/view'
  DailyGraphView = require 'views/timeline/daily-graph-view'

  Template  = require 'templates/timeline/weekly'


  class DailyView extends View
    template: Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()

  
    attach: ->
      super

      @subview 'graph', new DailyGraphView model: @model, container: 'div.chart'


    calculatedAttributes: ->
      info:
        minutes: @_calculatePhoneAverage()
        messages: @_calculateMessageAverage()
        whatsapp: @_calculateWhatsappAverage()


    _calculatePhoneAverage: ->
      duration = @model.getCalls().chain()
        .filter (call) ->
          d3.time.format('%Y')(new Date(call.get('date'))) is '2013'
        .reduce((memo, call) ->
          memo + call.get('duration')
        , 0)
        .value()

      duration = duration / 60 / 365
      duration = if duration > 1 then (duration).toFixed() else '< 1'


    _calculateMessageAverage: ->
      num = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('type') in ['SMS', 'MMS']
        .size()
        .value()
        
      num = num / 365
      num = if num > 1 then (num).toFixed() else '< 1'


    _calculateWhatsappAverage: ->
      num = @model.getMessages().chain()
        .filter (message) ->
          d3.time.format('%Y')(new Date(message.get('date'))) is '2013' and message.get('type') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD']
        .size()
        .value()

      num = num / 365
      num = if num > 1 then (num).toFixed() else '< 1'
      