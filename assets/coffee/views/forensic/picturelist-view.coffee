define (require) ->
  'use strict'


  View      = require 'views/base/view'
  
  Template  = require 'templates/forensic/picturelist'


  class PictureMapView extends View
    template:         Template




