class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user = current_user

    if @item.save
      redirect_to item_path(@item), flash: {success: 'Congrats – you just posted a new item! Now add some pictures for it from here. '}
    else
      render 'new'
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def calendar
    @start_date = Date.today.at_beginning_of_month
    @end_date = Date.today.at_end_of_month

    @rows = [nil] * @start_date.wday + (@start_date..@end_date).to_a
    @rows = @rows.each_slice(7).to_a

    render layout: nil
  end

  def index
    things = Item.order('updated_at DESC')

    puts params

    things = things.where(gender: Item.genders[params[:gender]]) if (params[:gender].present? && params[:gender] != 'any')
    things = things.where(category: params[:category]) if (params[:category].present? && params[:category] != 'any')
    if (params[:price_range].present? && params[:price_range] != 'any')
      low, high = params[:price_range].split('-')
      things = things.where('price >= ? AND price <= ?', low.to_i, high.to_i)
    end

    @items = things.all
  end

  private
    def item_params
      params.require(:item).permit(:size, :gender, :category, :price, :insurance_claim, :color, :brand)
    end
end
