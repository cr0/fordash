define (require) ->
  'use strict'

  require 'foundation'

  View        = require 'views/base/view'
  
  Template    = require 'templates/skeleton'


  class SkeletonView extends View
    container: 'section.content'
    id:        'skeleton'
    className: 'skeleton'
    regions:
      'info':      'article#info'
      'timeline':  'article#timeline'
      'overview':  'article#overview'
      'contact':   'article#contact'
      'message':   'article#message'
    template: Template

    attach: ->
      super
      console.debug "adding foundation to skeleton"
      @$el.foundation()