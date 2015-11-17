class ReservationsController < ApplicationController
  before_action :authenticate_user!, except: []

  def index
    @incoming_reservations = current_user.incoming_reservations
    @reservations = current_user.reservations.not_self_reserved
  end

  def cancel
    @reservation = Reservation.find(params[:id])

    unless @reservation.user == current_user
      redirect_to root_url, flash: {alert: 'You can only cancel your own reservations. '}
      return
    end

    @reservation.cancel
    @reservation.save!
    redirect_to reservations_url, flash: {success: 'You have cancelled that reservation. '}
  end

  def approve
    @reservation = Reservation.find(params[:id])

    unless @reservation.item.user == current_user
      redirect_to root_url, flash: {alert: 'You can only approve reservations made to your items. '}
      return
    end

    @reservation.approve
    @reservation.save!
    redirect_to reservations_url, flash: {success: 'You have approved that reservation. '}
  end

  def reject
    @reservation = Reservation.find(params[:id])

    unless @reservation.item.user == current_user
      redirect_to root_url, flash: {alert: 'You can only reject reservations made to your items. '}
      return
    end

    @reservation.reject
    @reservation.save!
    redirect_to reservations_url, flash: {success: 'You have rejected that reservation. '}
  end

  def pay
    @token = params[:stripe_token]
    @reservation = Reservation.find(params[:id])
    Stripe.api_key = stripe_secret_key

    unless @reservation.may_pay?
      redirect_to reservations_url, flash: {alert: 'You can only pay approved reservations. '}
      return
    end

    if @token.present?
      customer = Stripe::Customer.create(
        source: @token,
        description: current_user.name
      )

      current_user.update(stripe_customer_id: customer.id)
    end

    unless current_user.stripe_customer_id.present?
      redirect_to reservations_url, flash: {alert: 'No payment method available. '}
      return
    end

    begin
      Stripe::Charge.create(
        amount: (@reservation.price * 100).to_i,
        currency: 'usd',
        customer: current_user.stripe_customer_id
      )
    rescue Stripe::CardError => e
      redirect_to reservations_url, flash: {alert: 'You card has been declined. '}
      return
    end

    @reservation.pay
    @reservation.save!
    redirect_to reservations_url, flash: {alert: 'You have paid for the reservation. '}
  end
end
