class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.boolean :sugar
      t.boolean :antioxidant
      t.boolean :dye
      t.boolean :conserve
      t.boolean :phophate

      t.timestamps null: false
    end
  end
end
