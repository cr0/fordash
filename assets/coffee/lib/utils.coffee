define [
  'underscore'
  'chaplin'
], (_, Chaplin) ->
  'use strict'

  # Application-specific utilities
  # ------------------------------

  # Delegate to Chaplin’s utils module
  utils = Chaplin.utils.beget Chaplin.utils

  # Add additional application-specific properties and methods
  _(utils).extend

    formatFileSize: (bytes)->
      if typeof bytes is not 'number' then return ''
            
      if bytes >= 1000000000 then return "#{(bytes / 1000000000).toFixed(2)} GB"
      else if bytes >= 1000000 then return "#{(bytes / 1000000).toFixed(2)} MB"
      else if bytes >= 1000 then return "#{(bytes / 1000).toFixed(2)} KB"

    uuid4: () ->
      "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
        r = Math.random()*16|0
        v = if c is 'x' then r else r&0x3|0x8
        v.toString(16)

  utils
