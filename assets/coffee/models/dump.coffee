define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'
  Moment          = require 'moment'

  Model           = require 'models/base/model'
  Phone           = require 'models/phone'
  Contact         = require 'models/contact'
  Contacts        = require 'models/contacts'
  Picture         = require 'models/picture'
  Pictures        = require 'models/pictures'
  Browserhistory  = require 'models/browserhistory'
  Browserhistories= require 'models/browserhistories'
  Calendar        = require 'models/calendar'
  Calendars       = require 'models/calendars'
  Messages        = require 'models/messages'
  Calllogs        = require 'models/calllogs'
  

  class Dump extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/dumps/dumpId/"

    defaults:
      createdAt:            null
      formatted_createdAt:  null

    relations: [
      type:             'HasOne'
      key:              'phone'
      keySource:        'phoneId'
      relatedModel:     Phone
      autoFetch:        true
      reverseRelation:
        key:            'dumps'
    ,
      type:           'HasMany'
      key:            'contacts'
      relatedModel:   Contact
      collectionType: Contacts
      includeInJSON:  'id'
      reverseRelation:
        key:            'dump_id'
        includeInJSON:  no
    ,
      type:           'HasMany'
      key:            'pictures'
      relatedModel:   Picture
      collectionType: Pictures
      includeInJSON:  ['id']
      reverseRelation:
        key:            'dump_id'
        includeInJSON:  no
    ,
      type:           'HasMany'
      key:            'browserhistories'
      relatedModel:   Browserhistory
      collectionType: Browserhistories
      includeInJSON:  'id'
      reverseRelation:
        key:            'dump_id'
        includeInJSON:  no
    ,
      type:           'HasMany'
      key:            'calendars'
      relatedModel:   Calendar
      collectionType: Calendars
      includeInJSON:  'id'
      reverseRelation:
        key:            'dump_id'
        includeInJSON:  no
    ]

    initialize: (options) ->
      @on 'change:createdAt', @updateFormattedCreatedAt, @

    updateFormattedCreatedAt: (model, value, options) ->
      # Thu Jan 02 13:10:56 CET 2014
      @set 'formatted_createdAt', "#{Moment(value, 'ddd MMM DD HH:mm:ss [CET] YYYY').format('D. MMM YYYY, HH:mm:ss')} Uhr" if value? 

    getMessages: ->
      new Messages @get('contacts').chain()
        .map (contact) ->
          contact.get('phonenumbers').models
        .flatten()
        .map (phonenumber) ->
          phonenumber.get('messages').models
        .flatten()
        .value()

    getCalls: ->
      new Calllogs @get('contacts').chain()
        .map (contact) ->
          contact.get('phonenumbers').models
        .flatten()
        .map (phonenumber) ->
          phonenumber.get('calllogs').models
        .flatten()
        .value()