define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  Phonenumber     = require 'models/phonenumber'
  Phonenumbers    = require 'models/phonenumbers'
  Calllogs        = require 'models/calllogs'
  Messages        = require 'models/messages'


  ###*
   * Class representing a {Contact} which has several {Phonenumber}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Contact extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/contact/#{Chaplin.mediator.dumpid}/id/"

    defaults:
      name: '<UNKNOWN_CONTACT>'

    relations: [
      type:           'HasMany'
      key:            'phonenumbers'
      relatedModel:   Phonenumber
      collectionType: Phonenumbers
      includeInJSON:  ['phonenumbers']
      reverseRelation:
        key:            'contact'
        keySource:      'owner_id'
        includeInJSON:  no
    ]


    ###*
     * Get all {Messages} for a {Contact}
     *
     * @return {Messages} a collection with the {Contact}'s {Message}s
    ###
    getMessages: ->
      new Messages @get('phonenumbers')
        .chain()
        .map (phonenumber) ->
          phonenumber.get('messages').models
        .flatten()
        .value()


    ###*
     * Get all {Calllogs} for a {Contact}
     *
     * @return {Calllogs} a collection with the {Contact}'s {Calllog}s
    ###
    getCalls: ->
      new Calllogs @get('phonenumbers')
        .chain()
        .map (phonenumber) ->
          phonenumber.get('calllogs').models
        .flatten()
        .value()
