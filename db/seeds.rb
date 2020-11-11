include FactoryBot::Syntax::Methods

ItemOrder.destroy_all
Order.destroy_all
Review.destroy_all
Item.destroy_all
Merchant.destroy_all
User.destroy_all

merchant_1 = create(:merchant)

items = create_list(:item, 8, merchant_id: merchant_1.id)

item_orders_0 = create_list(:item_order, 2, item: items[0])
item_orders_1 = create_list(:item_order, 4, item: items[1])
item_orders_2 = create_list(:item_order, 8, item: items[2])
item_orders_3 = create_list(:item_order, 10, item: items[3])
item_orders_4 = create_list(:item_order, 1, item: items[4])
item_orders_5 = create_list(:item_order, 0, item: items[5])
item_orders_6 = create_list(:item_order, 3, item: items[6])
item_orders_7 = create_list(:item_order, 2, item: items[7])

inactive_item_1 = create(:inactive_item)
inactive_item_2 = create(:inactive_item)
create_list(:item_order, 10, item: inactive_item_1, quantity: 10000)
create_list(:item_order, 10, item: inactive_item_2, quantity: 10000)



user_1 = create(:user, email: 'user@gmail.com', password: 'password')
merchant_1 = create(:merchant_employee, email: 'merchant@gmail.com', password: 'password', merchant_id: merchant_1.id)
admin_1 = create(:admin, email: 'admin@gmail.com', password: 'password')