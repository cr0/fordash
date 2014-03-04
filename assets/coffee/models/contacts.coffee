define (require) ->
  'use strict'

  Chaplin       = require 'chaplin'

  Collection    = require 'models/base/collection'
  Contact       = require 'models/contact'


  ###*
   * Class representing a collection of {Contact}s
   *
   * @author Christian Roth
   * @version 0.0.1
   * @include Chaplin.EventBroker
  ###
  class Contacts extends Collection
    _.extend @prototype, Chaplin.EventBroker

    model:      Contact
    comparator: 'name'


    ###*
     * Query all {Contact} entries for a specific {Dump}
     *
     * @param  {String} dumpid
     * @return {Contacts}
    ###
    @forDump: (dumpid) ->
    	return new Contacts url: "#{Chaplin.mediator.urlprefix}/contact/#{dumpid}/all"
