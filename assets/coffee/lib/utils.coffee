define (require) ->
  'use strict'


  Chaplin = require 'chaplin'
  URI     = require 'URI'
  _       = require 'underscore'


  utils = Chaplin.utils.beget Chaplin.utils

  _(utils).extend

    ###*
     * Make filesizes human readable by grouping them to KB/MB/GB
     *
     * @param  {Number} bytes length of
     * @return {String}       bytes in a human readable format
    ###
    formatFileSize: (bytes)->
      if typeof bytes is not 'number' then return ''

      if bytes >= 1000000000 then return "#{(bytes / 1000000000).toFixed(2)} GB"
      else if bytes >= 1000000 then return "#{(bytes / 1000000).toFixed(2)} MB"
      else if bytes >= 1000 then return "#{(bytes / 1000).toFixed(2)} KB"


    ###*
     * Generate a random UUIDv4
     *
     * @return {String} A random UUIDv4
    ###
    uuid4: () ->
      "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
        r = Math.random()*16|0
        v = if c is 'x' then r else r&0x3|0x8
        v.toString(16)


    ###*
     * Normalize a URI, e.g. by removing multiple trailings slashes
     *
     * @param  {String} uri unnormalized URI
     * @return {String}     normalized URI
    ###
    normalizeUri: (uri) ->
      new URI(uri).normalize()


  utils
