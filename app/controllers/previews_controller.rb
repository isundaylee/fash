class PreviewsController < ApplicationController
  def create
    @preview = Preview.new(preview_params)
    @item = Item.find(@preview.item_id)

    if current_user.id != @item.user_id
      redirect_to root_url, flash: {alert: 'You cannot upload previews for items that do not belong to you. '}
    else
      @preview.save!
      redirect_to item_url(@preview.item), flash: {alert: 'You have successfully added a new image for this item. Continue below to add some more! '}
    end
  end

  private
    def preview_params
      params.require(:preview).permit(:item_id, :image)
    end
end
