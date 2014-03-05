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
  ForensicView        = require 'views/forensic/forensic-view'


  ###*
   * Main controller
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class HelloController extends Controller

    ###*
     * Create the main page. If no dump is selected redirect to {DumpController#select}.
     *
     * @param  {Object} params Route variables and GET Parameters
    ###
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
      new ForensicView region: 'forensic', model: dump

      if Chaplin.mediator.cid?
        console.info "Had a cid saved, redirecting"
        @redirectTo 'contact_show', id: params.id, cid: Chaplin.mediator.cid
