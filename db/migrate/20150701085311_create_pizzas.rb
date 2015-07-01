class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|
      t.references :order, index: true, foreign_key: true
      t.decimal :total

      t.timestamps null: false
    end
  end
end
