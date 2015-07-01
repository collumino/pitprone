class Order < ActiveRecord::Base
  belongs_to :user
  has_many :pizzas

  def pizza_in_progress
    return pizzas.last if pizzas.any?
    nil
  end

  def count_ingredients
    return 0 unless pizza_in_progress
    pizza_in_progress.pizza_items.count
  end

end
