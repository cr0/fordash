define (require) ->
  'use strict'

  Chaplin         = require 'chaplin'

  Model           = require 'models/base/model'
  

  class Picture extends Model
    _.extend @prototype, Chaplin.EventBroker

    urlRoot: -> "#{Chaplin.mediator.urlprefix}/media/#{Chaplin.mediator.dumpid}/name/"

    defaults:
      duration:   -1
      name:       '<UNKNOWN_NAME>'
      type:       '<UNKNOWN_TYPE>'
      url:        '<UNKNOWN_URL>'
      longitude:  0
      latitude:   0

    initialize: ->
      return super unless @get('id')
      fileext = @get('id').split('.').pop() 
      
      if fileext in ['jpg', 'jpeg', 'png', 'gif'] then @set('type', 'image')
      else if fileext in ['m4a', 'aac'] then @set('type', 'audio')
      else if fileext in ['mp4', 'mov'] then @set('type', 'video')

      @set 'url', "#{Chaplin.mediator.urlprefix}/media/#{Chaplin.mediator.dumpid}/show/#{@get('id')}"




