define (require) ->
  'use strict'

  $                   = require 'jquery'
  Chaplin             = require 'chaplin'
  Controller          = require 'controllers/base/controller'

  Dump                = require 'models/dump'
  Contact             = require 'models/contact'


  class ContactController extends Controller

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
