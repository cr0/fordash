define [
  'jquery'
  'views/base/view'
  'templates/header'
], ($, View, Template) ->
  'use strict'

  class HeaderView extends View
    container:  'header'
    template:   Template


     