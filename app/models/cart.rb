# frozen_string_literal: true

class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 unless @contents[item]
    @contents[item] += 1
  end

  def subtract_item(item)
    @contents[item] = 0 unless @contents[item]
    @contents[item] -= 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id, quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def find_discount(item)
    item.bulk_discounts.order(discount: :desc).first
  end

  def new_price(item)
    unless item.bulk_discounts.empty?
      discount = find_discount(item)
      return item.price - (item.price * (discount.discount / 100)) if @contents[item.id.to_s] >= discount.quantity
    end
    item.price
  end

  def apply_discount(item, discount)
    discount_total = @contents[item.id.to_s] * (item.price * (discount.discount / 100))
    @contents[item.id.to_s] * item.price - discount_total
  end

  def subtotal(item)
    unless item.bulk_discounts.empty?
      discount = find_discount(item)
      return apply_discount(item, discount) if @contents[item.id.to_s] >= discount.quantity
    end
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id, _quantity|
      item = Item.find(item_id)
      subtotal(item)
    end
  end
end
