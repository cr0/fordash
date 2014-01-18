define (require) ->
  'use strict'

  d3        = require 'd3'

  Model     = require 'models/base/model'

  View      = require 'views/base/view'
  MonthlyGraphView = require 'views/timeline/monthly-graph-view'

  Template  = require 'templates/timeline/monthly'


  class MonthlyView extends View
    template: Template
    year:     d3.time.format('%Y')(new Date())
    direction:'both'
    bindings:
      '.year':     'monthlyyear'
      '.minutes':  'monthlyminutes'
      '.messages': 'monthlymessages'
      '.whatsapp': 'monthlywhatsapp'
      '.events':   'monthlyevents'
      '.browser':  'monthlybrowsers'

    initialize: ->
      @calculatedAttributes()

      @subscribeEvent 'graph:yearchange', (year) => 
        @year = year
        @calculatedAttributes()

      @subscribeEvent 'graph:directionchange', (direction) => 
        @direction = direction
        @calculatedAttributes()

  
    attach: ->
      super

      @subview 'graph', new MonthlyGraphView model: @model, container: 'div.chart'


    calculatedAttributes: ->
      @model.set 'monthlyyear', @year
      @model.set 'monthlyminutes', @_calculatePhoneAverage()
      @model.set 'monthlymessages', @_calculateMessageAverage()
      @model.set 'monthlywhatsapp', @_calculateWhatsappAverage()
      @model.set 'monthlyevents', @_calculateEventsAverage()
      @model.set 'monthlybrowsers', @_calculateBrowsersAverage()


    _calculatePhoneAverage: ->
      direction = switch @direction
        when 'both' then ['INCOMING', 'OUTGOING']
        when 'in' then ['INCOMING']
        when 'out' then ['OUTGOING']

      duration = @model.getCalls().chain()
        .filter (call) =>
          d3.time.format('%Y')(new Date(call.get('date'))) is "#{@year}" and call.get('direction') in direction
        .reduce((memo, call) ->
          memo + call.get('duration')
        , 0)
        .value()

      duration = duration / 60 / 12
      duration = if duration > 1 then (duration).toFixed() else '< 1'


    _calculateMessageAverage: ->
      direction = switch @direction
        when 'both' then ['INCOMING', 'OUTGOING']
        when 'in' then ['INCOMING']
        when 'out' then ['OUTGOING']

      num = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['SMS', 'MMS'] and message.get('direction') in direction
        .size()
        .value()

      num = num / 12
      num = if num > 1 then (num).toFixed() else '< 1'


    _calculateWhatsappAverage: ->
      direction = switch @direction
        when 'both' then ['INCOMING', 'OUTGOING']
        when 'in' then ['INCOMING']
        when 'out' then ['OUTGOING']

      num = @model.getMessages().chain()
        .filter (message) =>
          d3.time.format('%Y')(new Date(message.get('date'))) is "#{@year}" and message.get('type') in ['WHATSAPPTEXT', 'WHATSAPPPIC', 'WHATSAPPVID', 'WHATSAPPAUD']  and message.get('direction') in direction
        .size()
        .value()

      num = num / 12
      num = if num > 1 then (num).toFixed() else '< 1'


    _calculateEventsAverage: ->
      num = @model.get('calendars').chain()
        .filter (calendar) =>
          d3.time.format('%Y')(new Date(calendar.get('start'))) is "#{@year}"
        .size()
        .value()

      num = num / 12
      num = if num > 1 then (num).toFixed() else '< 1'
      

    _calculateBrowsersAverage: ->
      num = @model.get('browserhistories').chain()
        .filter (browserhistory) =>
          d3.time.format('%Y')(new Date(browserhistory.get('start'))) is "#{@year}"
        .size()
        .value()

      num = num / 12
      num = if num > 1 then (num).toFixed() else '< 1'
      