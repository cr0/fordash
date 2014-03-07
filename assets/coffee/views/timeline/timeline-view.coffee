define (require) ->
  'use strict'

  d3              = require 'd3'

  DumpView        = require 'views/base/dump-view'
  HistoryView  		= require 'views/timeline/history-view'
  MonthlyView  		= require 'views/timeline/monthly-view'
  WeeklyView  		= require 'views/timeline/weekly-view'
  DialyView  		  = require 'views/timeline/daily-view'

  Template        = require 'templates/timeline/index'


  class TimelineView extends DumpView
    @DEFAULT_YEAR:      d3.time.format('%Y')(new Date())
    @DEFAULT_DIRECTION: 'both'

    template:           Template
    className:          'graph'
    regions:
      'history': 'div.history'
      'monthly': 'div.monthly'
      'weekly':  'div.weekly'
      'daily':   'div.daily'


    initialize: ->
      super

      @delegate 'click', 'a[data-direction]', (e) =>
        e.preventDefault()
        @publishEvent 'graph:directionchange', $(e.target).data('direction')

      @delegate 'click', 'a[data-year]', (e) =>
        e.preventDefault()
        @publishEvent 'graph:yearchange', $(e.target).data('year')


      @subscribeEvent 'graph:yearchange', (year) =>
        console.log "Year changed to #{year}"
        @$el.find("a[data-year]").removeClass('active')
        @$el.find("a[data-year='#{year}']").addClass('active')

      @subscribeEvent 'graph:directionchange', (direction) =>
        console.log "Direction changed to #{direction}"
        @$el.find("a[data-direction]").removeClass('active')
        @$el.find("a[data-direction='#{direction}']").addClass('active')


    render: ->
      super

      @publishEvent 'graph:yearchange', TimelineView.DEFAULT_YEAR
      @publishEvent 'graph:directionchange', TimelineView.DEFAULT_DIRECTION


    attach: ->
      super

      @subview 'history', new HistoryView model: @model, region: 'history'
      @subview 'monthly', new MonthlyView model: @model, region: 'monthly'
      @subview 'weekly', new WeeklyView model: @model, region: 'weekly'
      @subview 'daily', new DialyView model: @model, region: 'daily'
