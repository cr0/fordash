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


  ###*
   * Class representing a {Dump}. A dump is the base object holding any information such as {Contact}s, {Picture}s and
   * so on
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Dump extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "dumps/dumpId/"

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


    ###*
     * Create new {Dump}
     *
     * @param  {Object} A classic backbone constructor options hash
     * @return {Dump}
    ###
    initialize: (options) ->
      @on 'change:createdAt', @_updateFormattedCreatedAt, @


    ###*
     * Helper method for updating the {Dump#formatted_date} value. This property is normally used to output a date
     * in views
     *
     * @param  {Dump} model  The current {Dump} instance
     * @param  {Date} value  The new value of {Dump#date}
     * @param  {Object} options
     * @return {Dump} The current {Dump} instance
     * @private
    ###
    _updateFormattedCreatedAt: (model, value, options) ->
      # Thu Jan 02 13:10:56 CET 2014
      @set 'formatted_createdAt', "#{Moment(value, 'ddd MMM DD HH:mm:ss [CET] YYYY').format('D. MMM YYYY, HH:mm:ss')} Uhr" if value?


    ###*
     * Get all {Messages} for a {Dump} ignoring the associated {Contact}
     *
     * @return {Messages} a collection with the {Dump}'s {Message}s
    ###
    getMessages: ->
      messages = @get('contacts').chain()
        .map (contact) ->
          contact.get('phonenumbers').models
        .flatten()
        .map (phonenumber) ->
          phonenumber.get('messages').models
        .flatten()
        .value()
      new Messages messages


    ###*
     * Get all {Calllogs} for a {Dump} ignoring the associated {Contact}
     *
     * @return {Calllogs} a collection with the {Dump}'s {Calllog}s
    ###
    getCalls: ->
      calls = @get('contacts').chain()
        .map (contact) ->
          contact.get('phonenumbers').models
        .flatten()
        .map (phonenumber) ->
          phonenumber.get('calllogs').models
        .flatten()
        .value()
      new Calllogs calls
