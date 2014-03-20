define (require) ->
  'use strict'

  $                   = require 'jquery'
  _                   = require 'underscore'
  Chaplin             = require 'chaplin'

  Controller          = require 'controllers/base/controller'

  Dump                = require 'models/dump'
  Phone               = require 'models/phone'
  Contacts            = require 'models/contacts'
  Phonenumbers        = require 'models/phonenumbers'
  Calllogs            = require 'models/calllogs'
  Messages            = require 'models/messages'
  Browserhistories    = require 'models/browserhistories'
  Calendars           = require 'models/calendars'
  Pictures            = require 'models/pictures'

  LoadView            = require 'views/load-view'


  ###*
   * Controller handling the loading of {Dump}s
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class DumpController extends Controller
    @OFFCANVAS_EL:       'div.off-canvas-wrap'
    @OFFCANVAS_CLASSNAME:'move-right'


    ###*
     * Show a list of all {Dumps} (shows the off canvas list)
     *
     * @param  {Object} params Route variables and GET Parameters
    ###
    select: (params) ->
      @adjustTitle "Select dump"

      @publishEvent 'refresh:dumps'

      $(DumpController.OFFCANVAS_EL).addClass(DumpController.OFFCANVAS_CLASSNAME)


    ###*
     * Load a specific {Dump}
     *
     * @param  {Object} params Route variables and GET Parameters
    ###
    load: (params) ->
      @adjustTitle "Loading #{params.id}"
      Chaplin.mediator.dumpid = params.id
      Chaplin.mediator.publish 'dumpid:change', params.id

      $(DumpController.OFFCANVAS_EL).removeClass(DumpController.OFFCANVAS_CLASSNAME)

      loadView = new LoadView region: 'info'

      dump          = Dump.findOrCreate id: params.id
      contacts      = Contacts.forDump params.id
      phonenumbers  = Phonenumbers.forDump params.id
      calllogs      = Calllogs.forDump params.id
      messages      = Messages.forDump params.id
      browserhistories = Browserhistories.forDump params.id
      calendars     = Calendars.forDump params.id
      pictures      = Pictures.forDump params.id

      dump.fetch()
        .then (json) =>
          #TODO fix non autofetching phone model
          phone = Phone.findOrCreate id: json.phoneId
          console.debug "Received dump for", phone
          $.when phone.fetch(), contacts.fetch(), phonenumbers.fetch(), calllogs.fetch(), messages.fetch(), browserhistories.fetch(), calendars.fetch(), pictures.fetch()
        .always ->
          loadView.dispose()
        .done () =>
          console.debug "Received nested objects"
          console.debug contacts, phonenumbers, calllogs, messages, browserhistories, calendars, pictures
          dump.set 'contacts', contacts
          dump.set 'calendars', calendars
          dump.set 'browserhistories', browserhistories
          dump.set 'pictures', pictures
          @_validate params.id, contacts, phonenumbers, calllogs, messages, browserhistories, calendars, pictures
        .fail (e) =>
          console.error "Failed to received dump and/or nested objects: ", e
          @publishEvent '!error', new Error "An error occurred while requesting the dump from the server"


    ###*
     * Validate if a dump is feasable for usage
     * A dump needs more than one non whatsapp contact and more than one message, calllog and phonenumber
     *
     * @param  {String} id                          dumpid
     * @param  {Contacts} contacts                  A {Contact} collection
     * @param  {Phonenumbers} phonenumbers          A {Phonenumber} collection
     * @param  {Calllogs} calllogs                  A {Calllog} collection
     * @param  {Messages} messages                  A {Message} collection
     * @param  {Browserhistories} browserhistories  A {Browserhistory} collection
     * @param  {Calendars} calendars                A {Calendar} collection
     * @param  {Pictures} pictures                  A {Picture} collection
    ###
    _validate: (id, contacts, phonenumbers, calllogs, messages, browserhistories, calendars, pictures) ->
      console.debug 'validating if the dump is feasable'

      types = ['contacts', 'messages', 'calllogs', 'phonenumbers']
      ok = new Array
      ok[0] = contacts.filter((contact) -> contact.id != 9999).length > 0
      ok[1] = messages.filter((message) -> message.get('phonenumber').get('contact').id != 9999).length > 0
      ok[2] = calllogs.length > 0
      ok[3] = phonenumbers.length > 0

      if _.without(ok, true).length > 0
        console.error "dump is not feasable", ok
        types = ['contacts', 'messages', 'calllogs', 'phonenumbers']
        for type, i in types
          if ok[i] then types[i] = false
        return @publishEvent '!error', new Error "The received dump is not feasable (insufficient data: #{_.compact(types).join(', ')})"

      @redirectTo 'dashboard_home', id: id
