define (require) ->
  'use strict'

  d3        = require 'd3'

  View      = require 'views/base/view'
  DailyGraphView = require 'views/timeline/daily-graph-view'

  Template  = require 'templates/timeline/daily'


  class DailyView extends View
    template: Template
    year:     d3.time.format('%Y')(new Date())
    direction:'both'
    bindings:
      '.year':     'dailyyear'
      '.minutes':  'dailyminutes'
      '.messages': 'dailymessages'
      '.whatsapp': 'dailywhatsapp'
      '.events':   'dailyevents'
      '.browser':  'dailybrowsers'

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

      @subview 'graph', new DailyGraphView model: @model, container: 'div.chart'


    calculatedAttributes: ->
      @model.set 'dailyyear', @year
      @model.set 'dailyminutes', @_calculatePhoneAverage()
      @model.set 'dailymessages', @_calculateMessageAverage()
      @model.set 'dailywhatsapp', @_calculateWhatsappAverage()
      @model.set 'dailyevents', @_calculateEventsAverage()
      @model.set 'dailybrowsers', @_calculateBrowsersAverage()


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

      duration = duration / 60 / 365
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
        
      num = num / 365
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

      num = num / 365
      num = if num > 1 then (num).toFixed() else '< 1'
      

    _calculateEventsAverage: ->
      num = @model.get('calendars').chain()
        .filter (calendar) =>
          d3.time.format('%Y')(new Date(calendar.get('start'))) is "#{@year}"
        .size()
        .value()

      num = num / 365
      num = if num > 1 then (num).toFixed() else '< 1'
      

    _calculateBrowsersAverage: ->
      num = @model.get('browserhistories').chain()
        .filter (browserhistory) =>
          d3.time.format('%Y')(new Date(browserhistory.get('start'))) is "#{@year}"
        .size()
        .value()

      num = num / 365
      num = if num > 1 then (num).toFixed() else '< 1'