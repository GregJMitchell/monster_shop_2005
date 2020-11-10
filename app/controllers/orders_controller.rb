# frozen_string_literal: true

class OrdersController < ApplicationController
  def new; end

  def create
    order_params[:user_id] = current_user.id
    order = Order.create(order_params.merge(user_id: current_user.id).merge(status: 'Pending'))
    if order.save
      cart.items.each do |item, quantity|
        order.item_orders.create({ item: item,
                                   quantity: quantity,
                                   price: cart.new_price(item),
                                   merchant_id: item.merchant.id,
                                   status: 'Pending' })
      end
      session.delete(:cart)
      redirect_to '/profile/orders', notice: 'Your order has been created'
    else
      flash[:notice] = 'Please complete address form to create an order.'
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
