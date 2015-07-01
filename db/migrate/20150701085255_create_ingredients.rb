class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.references :property, index: true, foreign_key: true
      t.text :name
      t.text :additional_remarks
      t.decimal :price
      t.boolean :is_default
      t.boolean :vegan
      t.string :category
      t.timestamps null: false
    end
  end
end
