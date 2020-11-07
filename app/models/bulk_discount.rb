# frozen_string_literal: true

class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  belongs_to :item

  validates_presence_of :discount,
                        :quantity

  validates_numericality_of :discount, greater_than: 0
  validates_numericality_of :discount, less_than_or_equal_to: 100
end
