define [
  'jquery'
  'views/base/view'
  'templates/timeline'
], ($, View, Template) ->
  'use strict'

  class TimelineView extends View
    template:   Template