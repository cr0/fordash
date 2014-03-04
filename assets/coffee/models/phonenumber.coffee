define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  Calllog         = require 'models/calllog'
  Calllogs        = require 'models/calllogs'
  Message         = require 'models/message'
  Messages        = require 'models/messages'


  ###*
   * Class representing a {Phonenumber} which has {Calllogs} and {Messages} attached
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Phonenumber extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: "number/#{Chaplin.mediator.dumpid}/id/"

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


