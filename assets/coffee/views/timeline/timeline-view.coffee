define (require) ->
  'use strict'

  View            = require 'views/base/view'
  HistoryView  		= require 'views/timeline/history-view'
  MonthlyView  		= require 'views/timeline/monthly-view'
  WeeklyView  		= require 'views/timeline/weekly-view'
  
  Template        = require 'templates/timeline/index'


  class TimelineView extends View
    template:   Template
    className:  'graph'
    regions:
      'history': 'div.history'
      'monthly': 'div.monthly'
      'weekly':  'div.weekly'

    attach: ->
      super

      #@subview 'history', new HistoryView model: @model, region: 'history'
      @subview 'monthly', new MonthlyView model: @model, region: 'monthly'
      @subview 'weekly', new WeeklyView model: @model, region: 'weekly'
