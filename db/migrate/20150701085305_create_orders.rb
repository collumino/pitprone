class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :total , precision: 10, scale: 2, default: 0.0
      t.string :state

      t.timestamps null: false
    end
  end
end
