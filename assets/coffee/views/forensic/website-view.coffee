define (require) ->
  'use strict'

  $         = require 'jquery'

  View      = require 'views/base/view'
  
  Template  = require 'templates/forensic/website'


  class WebsiteView extends View
    template:         Template


    initialize: ->
      @delegate 'click', 'div.name[data-website-click]', (e) => 
        e.preventDefault()
        target = $(e.target).data('website-click')
        @$el.find("ul[data-website-target='#{target}']").slideToggle()


    getTemplateData: ->
      $.extend @model.attributes, @calculatedAttributes()


    calculatedAttributes: ->
      forensic:
        websites: @findTopWebsites()


    findTopWebsites: ->

      domainForUrl = (url) -> $('<a>').prop('href', url).prop('hostname').replace(/w{3}\./, '')

      sum = 0
      websites = @model.get('browserhistories').chain()
        .groupBy (website) ->
          domainForUrl website.get('url')
        .map (websites, domain) ->
          sum += websites.length
          score: websites.length
          domain: domain
          sites: _.map websites, (website) -> url: website.get('url'), title: website.get('title')
        .each((website) -> website.percent = "#{website.score / sum * 100}")
        .sortBy('score')
        .value()

      websites.reverse()

