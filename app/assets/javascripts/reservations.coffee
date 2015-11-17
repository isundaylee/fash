# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  if $('body#reservations_index').length > 0
    handler = StripeCheckout.configure(
      key: gon.stripePubKey
      image: '/img/documentation/checkout/marketplace.png'
      locale: 'auto'
      token: (token) ->
        window.current_form.find('[name=stripe_token]').val(token.id)
        window.current_form.submit()
        return
    )

    $('[data-amount]').click (e) ->
      window.current_form = $(this).parent().find('.stripe-token-form')
      if $(this).data('direct')
        window.current_form.submit()
      else
        handler.open
          name: 'FASH'
          description: 'Item rental. '
          amount: $(this).data('amount')
      e.preventDefault()

$(document).ready(ready)
$(document).on('page:load', ready)