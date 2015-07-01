class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :firstname
      t.string :street
      t.string :city
      t.string :phone
      t.string :mobile

      t.timestamps null: false
    end
  end
end
