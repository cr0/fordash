define (require) ->
  'use strict'

  Chaplin = require 'chaplin'
  utils   = require 'lib/utils'

  class Application extends Chaplin.Application
    title: 'forDASH'

    initMediator: ->
      Chaplin.mediator.dumpid = utils.uuid4()
      Chaplin.mediator.urlprefix = '//localhost:8080/android-forensic-server/rest'
      console.debug "Setting dumpid to #{Chaplin.mediator.dumpid}"
      super