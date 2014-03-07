define (require) ->
  'use strict'

  View        = require 'views/base/view'

  Template    = require 'templates/header'


  class HeaderView extends View
    container:  'header'
    template:   Template



