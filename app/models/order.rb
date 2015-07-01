class Order < ActiveRecord::Base
  belongs_to :user
  has_many :pizzas

  def pizza_in_progress
    return pizzas.last if pizzas.any?
    nil
  end

end
