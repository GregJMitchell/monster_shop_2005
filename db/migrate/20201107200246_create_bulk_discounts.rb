class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.references :item, foreign_key: true
      t.references :merchant, foreign_key: true
      t.float :discount
      t.integer :quantity
    end
  end
end
