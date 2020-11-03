class AddMerchantToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :item_orders, :merchant, foreign_key: true
  end
end
