# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('body#items_show').length > 0
    $('#upload_preview').click ->
      $('#new_preview input[type=file]').click()
      false
    $('#new_preview input[type=file]').change ->
      $('#new_preview input[type=submit]').click()
    $('#calendar').load('/items/' + $('#calendar').data('item_id') + '/calendar')

  if $('body#items_index').length > 0
    $('#index_search select').change ->
      $('#index_search').submit()

$(document).ready(ready)
$(document).on('page:load', ready)