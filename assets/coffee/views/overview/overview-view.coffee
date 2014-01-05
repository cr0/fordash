define (require) ->
  'use strict'

  View            = require 'views/base/view'
  ShortstatsView  = require 'views/overview/shortstats-view'
  NumbersPieView  = require 'views/overview/numberspie-view'
  CalllogPieView  = require 'views/overview/calllogpie-view'
  MessagePieView  = require 'views/overview/messagepie-view'
  TopcontactView  = require 'views/overview/topcontact-view'
  TimestatsView   = require 'views/overview/timestats-view'
  
  Template        = require 'templates/overview/index'


  class OverviewView extends View
    template:   Template
    className:  'graph'
    regions:
      'shortstats': 'div.shortstats'
      'numberspie': 'div.pie.numbers'
      'calllogpie': 'div.pie.calllogs'
      'messagepie': 'div.pie.messages'
      'topcontact': 'div.topcontact'
      'timestats':  'div.timestats'

    attach: ->
      super

      @subview 'shortstats', new ShortstatsView model: @model, region: 'shortstats'
      @subview 'numberspie', new NumbersPieView model: @model, region: 'numberspie'
      @subview 'calllogpie', new CalllogPieView model: @model, region: 'calllogpie'
      @subview 'messagepie', new MessagePieView model: @model, region: 'messagepie'
      @subview 'topcontact', new TopcontactView model: @model, region: 'topcontact'
      @subview 'timestats', new TimestatsView model: @model, region: 'timestats'
