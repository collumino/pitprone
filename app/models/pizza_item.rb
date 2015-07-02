class PizzaItem < ActiveRecord::Base
  belongs_to :pizza
  belongs_to :ingredient

  def recalculate
    self.update( total: calculate )
  end

  private

  def calculate
    total = self.quantity * self.ingredient.price
    total *= pizza.size_factor if self.persisted?
  end

end
