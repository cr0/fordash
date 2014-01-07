define (require) ->
  'use strict'

  $                   = require 'jquery'
  Chaplin             = require 'chaplin'
  Controller          = require 'controllers/base/controller'

  Dump                = require 'models/dump'

  DumpinfoView        = require 'views/info/dumpinfo-view'
  TimelineView        = require 'views/timeline/timeline-view'
  OverviewView        = require 'views/overview/overview-view'
  ContactView         = require 'views/contact/contact-view'
  MessageView         = require 'views/graph/message-view'


  class HelloController extends Controller

    home: (params) ->
      @adjustTitle 'Hello'

      dump = Dump.find id: params.id
      if not dump 
        console.error "Dump is null, redirecting to load dump."
        return @redirectTo 'dump_load', id: params.id

      new DumpinfoView region: 'info', model: dump
      new TimelineView region: 'timeline', model: dump
      new OverviewView region: 'overview', model: dump
      new ContactView region: 'contact', model: dump
      new MessageView region: 'message', model: dump