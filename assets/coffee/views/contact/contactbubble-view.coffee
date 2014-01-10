define (require) ->
  'use strict'

  _         = require 'underscore'
  d3        = require 'd3'
  Chaplin   = require 'chaplin'

  View      = require 'views/base/view'

  Template  = require 'templates/contact/bubble'


  class ContactBubbleView extends View
    @MESSAGES_MULTI:  0.15
    @MINUTES_MULTI:   0.5
    @MAX_BUBBLE_SIZE: 5

    template:         Template

    attach: ->
      super

      width = 800
      height = 500
      color = d3.scale.category20c()

      bubble = d3.layout.pack()
        .sort(null)
        .size([width, height])
        .padding(1.5)

      data = bubble.nodes(@data())

      svg = d3.select(@$el.find('div.graph')[0])
        .append("svg")
          .attr("width", width)
          .attr("height", height)
          .attr("class", "bubble")

      node = svg.selectAll(".node")
        .data(data.filter((d) -> d.depth is 1))
        .enter()
          .append("g")
            .attr("class", "node")
            .attr "transform", (d) -> "translate(" + d.x + "," + d.y + ")"
            

      node.append("title")
        .text((d) -> "#{d.name}: #{d.minutes} Minuten telefoniert und #{d.messages} Nachrichten verschickt/empfangen")

      node.append("circle")
        .attr("r", (d) -> return d.r)
        .style("fill", (d) -> color(d.value) )

      node.append("text")
        .attr("dy", ".3em")
        .style("text-anchor", "middle")
        .text((d) -> d.name.slice(0, d.r / 3))

      node.on 'click', (d) => Chaplin.utils.redirectTo 'contact_show', id: @model.id, cid: d.id


      d3.select(self.frameElement).style("height", height + "px");

    data: ->
      contacts = @model.get('contacts').chain()
        .map (contact) ->
          minutes = contact.get('phonenumbers').reduce (memo, phonenumber) ->
            memo + phonenumber.get('calllogs').reduce (memo, calllog) ->
              memo + calllog.get('duration')
            , 0
          , 0

          messages = contact.get('phonenumbers').reduce (memo, phonenumber) ->
            memo + phonenumber.get('messages').length
          , 0

          name: contact.get('name')
          id: contact.id
          value: minutes * ContactBubbleView.MINUTES_MULTI + messages * ContactBubbleView.MESSAGES_MULTI
          messages: messages
          minutes: (minutes / 60).toFixed(2)
        .value()

      maxValue      = _.max(contacts, 'value').value
      sizeModifier  = ContactBubbleView.MAX_BUBBLE_SIZE / maxValue
      console.debug "maxvalue is #{maxValue}, normalizing with #{sizeModifier}"

      name: 'contacts', children: _.map contacts, (contact) ->
        name: contact.name
        id: contact.id
        value: Math.pow 3, contact.value * sizeModifier
        minutes: contact.minutes
        messages: contact.messages