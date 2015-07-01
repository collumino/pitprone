class PizzaItem < ActiveRecord::Base
  belongs_to :pizza
  belongs_to :ingredient
end
