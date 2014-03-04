define ->
  'use strict'

  (match) ->
    match '',   												'dump#select',  		name: 'dump_select'
    match 'dashboard/:id',							'dashboard#home', 	name: 'dashboard_home'
    match 'load/:id', 									'dump#load', 				name: 'dump_load'
    match 'dashboard/:id/contact/:cid', 'contact#show', 		name: 'contact_show'

    match '*notfound',                  'dump#select'
