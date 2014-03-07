define (require) ->
  'use strict'

  View        = require 'views/base/view'

  Template    = require 'templates/load'


  class LoadView extends View
    id:        'load'
    className: 'load'
    template:  Template
