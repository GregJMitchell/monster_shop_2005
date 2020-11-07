class Merchant:: BulkDiscountsController < Merchant::BaseController
  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    item = Item.find_by_merchant(params[:bulk_discount][:item_name], params[:bulk_discount][:merchant_id])
    if item
      @bulk_discount = BulkDiscount.new(discount_params.merge(item_id: item.id))
      if @bulk_discount.save
        flash[:notice] = "Your discount has been saved"
        redirect_to "/merchant"
      else
        flash[:error] = @bulk_discount.errors.full_messages.to_sentence
        render :new
      end
    else
      flash[:error] = "An item by that name at your merchant does not exist"
      render :new
    end
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:discount, :quantity, :merchant_id)
  end
end