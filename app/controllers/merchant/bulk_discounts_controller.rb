class Merchant:: BulkDiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end
  
  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    item = Item.find_by_merchant(params[:bulk_discount][:item_name], params[:bulk_discount][:merchant_id])
    if item
      @bulk_discount = BulkDiscount.new(discount_params.merge(item_id: item.id))
      if @bulk_discount.save
        flash[:notice] = "Your discount has been saved"
        redirect_to "/merchant/bulk_discounts"
      else
        flash[:error] = @bulk_discount.errors.full_messages.to_sentence
        render :new
      end
    else
      flash[:error] = "An item by that name at your merchant does not exist"
      render :new
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    item = Item.find_by_merchant(params[:bulk_discount][:item_name], params[:bulk_discount][:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if item
      @bulk_discount.update(discount_params.merge(item_id: item.id))
      if @bulk_discount.save
        flash[:notice] = "Your discount has been updated"
        redirect_to "/merchant/bulk_discounts/#{@bulk_discount.id}"
      else
        flash[:error] = @bulk_discount.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:error] = "An item by that name at your merchant does not exist"
      render :edit
    end
  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:discount, :quantity, :merchant_id)
  end
end