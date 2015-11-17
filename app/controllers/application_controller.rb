class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :initialize_flash
  before_action :store_stripe_pub_key

  private
    def store_stripe_pub_key
      gon.stripePubKey = Rails.env.production? ? ENV['STRIPE_PUB_KEY'] : 'pk_test_zTRHLkpO1B6uUKnzk7BGN8qS'
    end

    def stripe_secret_key
      Rails.env.production? ? ENV['STRIPE_SECRET_KEY'] : 'sk_test_yQtCnMul302g0SzEXytVtJNA'
    end

    def initialize_flash
        @flash = {}
    end
end
