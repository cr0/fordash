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


    render: ->
      super
      $main = @$el.find('section.main-section')
      $nav  = @$el.find('nav')

      $nav
        .mouseenter -> $nav.removeClass('fixed') if $nav.data('fixed')
        .mouseleave -> $nav.addClass('fixed') if $nav.data('fixed')

      $main.scroll () ->
        if $main.scrollTop() > 60 then $nav.addClass('fixed').data('fixed', yes)
        else $nav.removeClass('fixed').data('fixed', no)


    attach: ->
      super
      console.debug "adding foundation to skeleton"
      #FIXME Foundation's mangellan is such buggy, many wow
      #$(document).foundation('mangellan', 'init')
      $(document).foundation('offcanvas', 'init')

      #console.debug "adding smoothscroll"
      #@$el.smoothScroll()
