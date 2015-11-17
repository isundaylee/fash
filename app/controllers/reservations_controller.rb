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
end
