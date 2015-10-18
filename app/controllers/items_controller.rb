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

  private
    def item_params
      params.require(:item).permit(:size, :gender, :category, :price, :insurance_claim, :color, :brand)
    end
end
