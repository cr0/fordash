define (require) ->
  'use strict'

  require 'foundation'

  View        = require 'views/base/view'
  
  Template    = require 'templates/load'


  class LoadView extends View
    id:        'load'
    className: 'load'
    template:  Template