define (require) ->
  'use strict'

  require 'foundation'
  require 'jquery.smooth-scroll'

  View        = require 'views/base/view'

  Template    = require 'templates/skeleton'


  ###*
   * View creating the structure of the page by providing regions for the view modules
   *
   * @author Christian Roth
   * @version 0.0.1
  ###
  class SkeletonView extends View
    container: 'section.content'
    id:        'skeleton'
    className: 'skeleton'
    regions:
      'loader':    'aside.loader'
      'info':      'article#info'
      'timeline':  'article#timeline'
      'overview':  'article#overview'
      'contact':   'article#contact'
      'forensic':  'article#forensic'
    template: Template

    initialize: ->
      @delegate 'click', 'dd.dump.left-off-canvas-toggle', => @publishEvent 'refresh:dumps'
      super


    attach: ->
      super
      console.debug "adding foundation to skeleton"
      @$el.foundation()

      #console.debug "adding smoothscroll"
      #@$el.smoothScroll()
