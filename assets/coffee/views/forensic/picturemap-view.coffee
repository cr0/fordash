define (require) ->
  'use strict'

  require 'jquery.preload'
  require 'jquery.exif'

  $         = require 'jquery'
  gmaps     = require 'gmaps'

  View      = require 'views/base/view'
  
  Template  = require 'templates/forensic/picturemap'


  class PictureMapView extends View
    template:         Template

    attach: ->
      super

      @map = new gmaps.Map @$el.find('div.map')[0], 
        zoom:   6
        center: new gmaps.LatLng 51.5167, 9.9167

      imagesToLoad = @model.get('pictures').chain()
        .filter (picture) ->
          picture.get('type') is 'image'
        .each (picture) =>
          return if picture.get('latitude') is 0 or  picture.get('longitude') is 0
          marker = new google.maps.Marker
            position: new gmaps.LatLng picture.get('latitude'), picture.get('longitude')
            title:    picture.get('name')

          marker.setMap @map




