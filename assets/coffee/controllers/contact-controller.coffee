define (require) ->
  'use strict'

  $                   = require 'jquery'
  Chaplin             = require 'chaplin'
  Controller          = require 'controllers/base/controller'

  Dump                = require 'models/dump'
  Contact             = require 'models/contact'


  ###*
   * Controller handling {Contact} related actions like showing a contact's details
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class ContactController extends Controller

    ###*
     * Show details for a {Contact}. If no dump is selected redirect to {DumpController#select}.
     *
     * @param  {Object} params Route variables and GET Parameters
    ###
    show: (params) ->

      dump = Dump.find id: params.id
      if not dump
        console.error "Dump is null, redirecting to load dump."
        Chaplin.mediator.cid = params.cid
        return @redirectTo 'dump_load', id: params.id

      contact = Contact.find params.cid
      if not contact
        console.error "Contact id not found"
        return

      Chaplin.mediator.publish 'contact:change', contact
