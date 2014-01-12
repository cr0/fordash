define (require) ->
  'use strict'


  Collection = require 'models/base/collection'

  View       = require 'views/base/view'
  TimestampResultView = require 'views/forensic/timestamp-result-view'
  
  Template   = require 'templates/forensic/timestamp'


  class TimestampView extends View
    @PLUSMINUS:       300 * 1000
    template:         Template

    initialize: ->
      @delegate 'blur', 'input[type="datetime-local"]', (e) => 
        @update Date.parse e.target.value


    update: (datetime) ->
      @resultView.dispose() if @resultView
      @resultView = new TimestampResultView model: @data(datetime), container: @$el.find('div.results')

    data: (datetime) ->
      datetimeAsData = new Date datetime
      upper = datetime + TimestampView.PLUSMINUS + datetimeAsData.getTimezoneOffset() * 1000 * 60
      lower = datetime - TimestampView.PLUSMINUS + datetimeAsData.getTimezoneOffset() * 1000 * 60
      console.debug "Filter using #{lower} < * < #{upper} (offset: #{datetimeAsData.getTimezoneOffset() * 1000 * 60})"

      results = new Collection

      calls = @model.getCalls().chain()
        .filter (call) ->
          lower < call.get('date') < upper
        .value()

      results.add calls

      messages = @model.getMessages().chain()
        .filter (message) ->
          lower < message.get('date') < upper
        .value()

      results.add messages

      results


