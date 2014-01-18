define (require) ->
  'use strict'

  $                   = require 'jquery'
  Chaplin             = require 'chaplin'

  Controller          = require 'controllers/base/controller'

  Dump                = require 'models/dump'
  Dumps               = require 'models/dumps'
  Contacts            = require 'models/contacts'
  Phonenumbers        = require 'models/phonenumbers'
  Calllogs            = require 'models/calllogs'
  Messages            = require 'models/messages'
  Browserhistories    = require 'models/browserhistories'
  Calendars           = require 'models/calendars'
  Pictures            = require 'models/pictures'

  DumpSelectView      = require 'views/dump/select-view'
  LoadView            = require 'views/load-view'


  class DumpController extends Controller

    select: (params) ->
      @adjustTitle "Select dump"

      dumps = new Dumps
      loadView = new LoadView region: 'info'

      dumps.fetch()
        .then ->
          dumps.each (dump) -> dump.fetch()
        .always ->
          loadView.dispose()
        .done -> 
          console.debug "Received #{dumps.length} dumps: ", dumps
          new DumpSelectView region: 'info', collection: dumps
        .fail (e) ->
          console.error "Failed to received dumps: ", e


    load: (params) ->
      @adjustTitle "Loading #{params.id}"
      Chaplin.mediator.dumpid = params.id
      Chaplin.mediator.publish 'dumpid:change', params.id

      loadView = new LoadView region: 'info'

      dump          = Dump.findOrCreate id: params.id
      contacts      = Contacts.forDump params.id
      phonenumbers  = Phonenumbers.forDump params.id
      calllogs      = Calllogs.forDump params.id
      messages      = Messages.forDump params.id
      browserhistories = Browserhistories.forDump params.id
      calendars     = Calendars.forDump params.id
      pictures      = Pictures.forDump params.id

      $.when dump.fetch(), contacts.fetch(), phonenumbers.fetch(), calllogs.fetch(), messages.fetch(), browserhistories.fetch(), calendars.fetch(), pictures.fetch()
        .always ->
          loadView.dispose()
        .done => 
          console.debug "Received dump and nested objects"
          console.debug dump, contacts, phonenumbers, calllogs, messages, browserhistories, calendars, pictures
          dump.set 'contacts', contacts
          dump.set 'calendars', calendars
          dump.set 'browserhistories', browserhistories
          dump.set 'pictures', pictures
          @redirectTo 'dashboard_home', id: params.id
        .fail (e) =>
          console.error "Failed to received dump and/or nested objects: ", e