define (require) ->
  'use strict'

  require 'backbone.stickit'

  View       = require 'views/base/view'


  ###*
   * A {Chaplin.View} which disposes itself when the dumpid changes
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class DumpView extends View

    initialize: ->
      super
      @subscribeEvent 'dumpid:change', =>
        console.debug "dumpid changed, need to dispose myself"
        @dispose()
