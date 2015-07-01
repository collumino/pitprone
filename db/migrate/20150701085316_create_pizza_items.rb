class CreatePizzaItems < ActiveRecord::Migration
  def change
    create_table :pizza_items do |t|
      t.references :pizza, index: true, foreign_key: true
      t.references :ingredient, index: true, foreign_key: true
      t.integer :quantity
      t.decimal :total

      t.timestamps null: false
    end
  end
end
