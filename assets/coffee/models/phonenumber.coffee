define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  Calllog         = require 'models/calllog'
  Calllogs        = require 'models/calllogs'
  Message         = require 'models/message'
  Messages        = require 'models/messages'
  

  class Phonenumber extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "#{Chaplin.mediator.urlprefix}/number/#{Chaplin.mediator.dumpid}/id/"

    defaults:
      number: '<UNKNOWN_NUMBER>'
      cc:     '<UNKNOWN_CC>'
      type:   '<UNKNOWN_TYPE>'

    relations: [
      type:           'HasMany'
      key:            'calllogs'
      relatedModel:   Calllog
      collectionType: Calllogs
      includeInJSON:  ['calllogs']
      reverseRelation:
        key:            'phonenumber'
        keySource:      'numberId'
        includeInJSON:  no
    ,
      type:           'HasMany'
      key:            'messages'
      relatedModel:   Message
      collectionType: Messages
      includeInJSON:  ['messages']
      reverseRelation:
        key:            'phonenumber'
        keySource:      'numberId'
        includeInJSON:  no
    ]


