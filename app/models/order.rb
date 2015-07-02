class Order < ActiveRecord::Base
  belongs_to :user
  has_many :pizzas, dependent: :destroy

  def pizza_in_progress
    return pizzas.last if pizzas.any?
    nil
  end

  def count_ingredients
    return 0 unless pizza_in_progress
    pizza_in_progress.pizza_items.count
  end

  def recalculate
    pizzas.each{|pizza|
      pizza.pizza_items.each{|pit| pit.recalculate }
      pizza.recalculate
    }
    self.update( total: calculate)
  end

  def sign_price
    rounded = self.total.round(2)
    value = sprintf('%.02f', rounded )
    "#{value} CHF"
  end
  private

  def calculate
    pizzas.inject(0){|sum, pizza| sum + pizza.total }
  end

end
