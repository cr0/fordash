define (require) ->
  'use strict'

  _         = require 'underscore'
  links     = require 'links'

  View      = require 'views/base/view'

  Template  = require 'templates/timeline/history'


  class HistoryView extends View
    @MINIMAL_EVENT_DURATION: 120 * 1000

    items:      ['phone', 'message', 'browser', 'calendar']
    template:   Template
    events:
      'change select.contacts': (contact...) ->
        console.log "selected contact", contact

    initialize: ->
      @delegate 'click', 'a[data-timeline]', (e) => 
        e.preventDefault()
        item = $(e.target).data('timeline')
        pos = @items.indexOf(item)
        if pos is -1 then @items.push item
        else @items.splice pos, 1
        @update()

      @delegate 'blur', 'input[type="date"]', (e) => 
        @_animateStart(e.target.valueAsDate)


    attach: ->
      super

      @timeline = new links.Timeline(@$el.find('div.links')[0])
      @timeline.draw @_getData(), 
        cluster:    yes
        min:        new Date(1970, 1, 1)
        max:        new Date()
        height:     '450px'


    update: ->
      @$el.find("a[data-timeline]").removeClass('active')
      for item in @items
        @$el.find("a[data-timeline='#{item}']").addClass('active')

      @timeline.deleteAllItems()
      @timeline.setData(@_getData())


    _getData: ->
      messages = calls = events = browsers = []

      if _.contains @items, 'message'
        messages = @model.getMessages().map (message) ->
          direction = if message.get('direction') is 'OUTGOING' then 'an' else 'von'

          start:    new Date(message.get('date'))
          content:  "Nachricht #{direction} #{message.get('phonenumber').get('contact').get('name')}"

      if _.contains @items, 'phone'
        calls = @model.getCalls().map (calllog) ->
          direction = if calllog.get('direction') is 'OUTGOING' then 'an' else 'von'
          contactName = calllog.get('phonenumber').get('contact').get('name')
          
          switch calllog.get('duration')
            when 0
              message = if direction is 'an' then "Unbeantworter Anruf an #{contactName}" else "Verpasster Anruf von #{contactName}"
            else message = "Anruf #{direction} #{contactName}"

          start:    new Date(calllog.get('date'))
          end:      new Date(calllog.get('date') + calllog.get('duration') * 1000) if calllog.get('duration') > 120
          content:  message

      if _.contains @items, 'calendar'
        events = @model.get('calendars').map (calendar) ->
          start:    new Date(calendar.get('start'))
          end:      new Date(calendar.get('end')) if calendar.get('end') - HistoryView.MINIMAL_EVENT_DURATION > calendar.get('start')
          content:  "Termin: #{calendar.get('title')}"

      if _.contains @items, 'browser'
        browsers = @model.get('browserhistories').map (browserhistory) ->
          start:    new Date(browserhistory.get('date'))
          content:  "Webseite: #{browserhistory.get('title')}"

      _.union messages, calls, events, browsers


    _animateStart: (date) ->
      animateFinal = date.valueOf()
      @timeline.setCustomTime(date)

      @_animateCancel()

      animate = () =>
        range = @timeline.getVisibleChartRange()
        current = (range.start.getTime() + range.end.getTime())/ 2
        width = (range.end.getTime() - range.start.getTime())
        minDiff = Math.max(width / 1000, 1)
        diff = (animateFinal - current)

        if Math.abs(diff) > minDiff
          start = new Date(range.start.getTime() + diff / 4)
          end = new Date(range.end.getTime() + diff / 4)
          @timeline.setVisibleChartRange(start, end);
          @_animateTimeout = setTimeout(animate, 50)

      animate()

    _animateCancel: ->
      if @_animateTimeout
        clearTimeout @_aanimateTimeout
        @_animateTimeout = undefined