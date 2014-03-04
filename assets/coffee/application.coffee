define (require) ->
  'use strict'

  Chaplin = require 'chaplin'
  utils   = require 'lib/utils'


  ###*
   * The forDASH application
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class Application extends Chaplin.Application
    title: 'forDASH'


    ###*
     * Add some cross application properties to the {Chaplin.Mediator}. {Chaplin.Mediator} is sealed afterwards
     * prohibiting its extension.
    ###
    initMediator: ->
      Chaplin.mediator.dumpid = utils.uuid4()
      Chaplin.mediator.cid = null
      Chaplin.mediator.urlprefix = '//localhost:8080/android-forensic-server/rest'
      console.debug "Setting dumpid to #{Chaplin.mediator.dumpid}"
      super
