define (require) ->
  'use strict'

  Chaplin   = require 'chaplin'
  Moment    = require 'moment'

  View      = require 'views/base/view'
  
  Template  = require 'templates/overview/timestats'


  class TimestatsView extends View
    @MSG_MEDIUM: ['SMS', 'MMS', 'WHATSAPPTEXT']
    template:   Template

    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()


    calculatedAttributes: ->
      timestats:
        month: 
          most: @_getTopMonth()
        day:
          most: @_getTopDay()
        hour:
          most: @_getTopHour()
        calls:
          average: @_getAverageCallDuration()
        messages:
          average: @_getAverageMessageLength()


    _getTopMonth: ->
      tmpCol = new Chaplin.Collection 
      tmpCol.add @model.getMessages().models
      tmpCol.add @model.getCalls().models

      topMonthItem = tmpCol.chain()
        .groupBy (model) ->
          Moment.unix(model.get('date')).month()
        .max (value) ->
          value.length
        .last()
        .value()

      tmpCol.reset()
      tmpCol = null

      Moment.unix(topMonthItem.get('date')).format('MMMM')


    _getTopDay: ->
      tmpCol = new Chaplin.Collection 
      tmpCol.add @model.getMessages().models
      tmpCol.add @model.getCalls().models

      topDayItem = tmpCol.chain()
        .groupBy (model) ->
          Moment.unix(model.get('date')).day()
        .max (value) ->
          value.length
        .last()
        .value()

      tmpCol.reset()
      tmpCol = null

      Moment.unix(topDayItem.get('date')).format('dddd')


    _getTopHour: ->
      tmpCol = new Chaplin.Collection 
      tmpCol.add @model.getMessages().models
      tmpCol.add @model.getCalls().models

      topHourItem = tmpCol.chain()
        .groupBy (model) ->
          Moment.unix(model.get('date')).hour()
        .max (value) ->
          value.length
        .last()
        .value()

      tmpCol.reset()
      tmpCol = null

      startHour = Moment.unix(topHourItem.get('date')).format('H')
      "#{startHour}:00 - #{startHour}:59"


    _getAverageCallDuration: ->
      totalCallDuration = @model.getCalls().reduce (memo, calllog) ->
        memo + calllog.get('duration')
      , 0 

      (totalCallDuration / @model.getCalls().length / 60).toFixed(2)


    _getAverageMessageLength: ->
      i = 0
      totalMessageLength = @model.getMessages().reduce (memo, message) ->
        msgMedium = message.get('type')
        if msgMedium in TimestatsView.MSG_MEDIUM
          i++
          memo + message.get('text').length
        else 
          memo
      , 0 

      (totalMessageLength / i).toFixed(2)


