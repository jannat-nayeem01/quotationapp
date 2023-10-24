class AddCategoryIdToQuotations < ActiveRecord::Migration[7.0]
  def change
    add_reference :quotations, :category, null: false, foreign_key: true
  end
end
