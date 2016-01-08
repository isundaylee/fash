class RatingsController < ApplicationController
  before_action :authenticate_user!, except: []

  def new
    @reservation = Reservation.find(params[:reservation_id])
    @rating = @reservation.ratings.new(user_id: current_user.id)

    unless @reservation.may_rate?(current_user)
      redirect_to reservations_path, flash: {alert: 'You may only rate your own completed reservation. '}
    end
  end

  def create
    @reservation = Reservation.find(params[:reservation_id])
    @rating = @reservation.ratings.new(rating_params.merge(user_id: current_user.id))

    @rating.save!

    redirect_to reservations_path, flash: {success: 'Thanks for rating the reservation! '}
  end

  private
    def rating_params
      params.require(:rating).permit(:rating, :review)
    end
end
