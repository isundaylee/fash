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
    $(document).on 'mouseover', '#calendar_table td', ->
      day = $(this).data('day')
      unavailable = $(this).hasClass('unavailable')
      $('#calendar_table td.active').removeClass('active')

      if !window.selecting
        $(this).addClass('active') unless unavailable
      else
        a = window.start_day
        b = day
        start = Math.min(a, b)
        end = Math.max(a, b)
        has_unavailable = false
        for i in [start..end]
          if $('#calendar_table td[data-day=' + i + ']').hasClass('unavailable')
            has_unavailable = true
        window.selection_valid = !has_unavailable
        window.selection_start = start
        window.selection_end = end
        unless has_unavailable
          for i in [start..end]
            $('#calendar_table td[data-day=' + i + ']').addClass('active')
    $(document).on 'click', '#calendar_table td', ->
      day = $(this).data('day')
      if !window.selecting
        window.selecting = true
        window.start_day = day
      else
        window.selecting = false
        if window.selection_valid
          month_prefix = $('#calendar_table').data('month_prefix')
          $('input#reservation_start_date').val(month_prefix + '-' + window.selection_start)
          $('input#reservation_end_date').val(month_prefix + '-' + window.selection_end)
          $('#new_reservation').submit()
      $(this).mouseover()

  if $('body#items_index').length > 0
    $('#index_search select').change ->
      $('#index_search').submit()

$(document).ready(ready)
$(document).on('page:load', ready)