class Pizza < ActiveRecord::Base
  has_many :pizza_items, -> { order("#{PizzaItem.table_name}.created_at ASC") }, dependent: :destroy
  belongs_to :order
end
