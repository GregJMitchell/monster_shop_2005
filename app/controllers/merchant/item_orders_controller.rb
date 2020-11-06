# frozen_string_literal: true

class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:itemorder_id])
    item_order.assign_attributes(status: 'Fulfilled')
    if item_order.save
      item_order.item.update(inventory: (item_order.item.inventory - item_order.quantity))
      redirect_to "/merchant/orders/#{item_order.order.id}", notice: "#{item_order.item.name} fulfilled"
    end
  end
end
