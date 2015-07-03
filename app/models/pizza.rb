class Pizza < ActiveRecord::Base
  has_many :pizza_items, -> { order("#{PizzaItem.table_name}.created_at ASC") }, dependent: :destroy
  belongs_to :order


  class << self
    def measures
      hsh= {}
      diameter = [25,28,32]
      self.sizes_and_weights.keys.each_with_index{|key, index| hsh[key] = diameter[index] }
      hsh
    end

    def weight(size)
      self.sizes_and_weights[size]
    end

    def sizes_and_weights
      { 'small' => 1.0, 'medium' => 1.25, 'big' => 1.50 }
    end

  end

  def size
    Pizza.sizes_and_weights.invert[self.size_factor]
  end

  def prepare
    Ingredient.default.each{|base|
      self.pizza_items << PizzaItem.create( quantity: 1, ingredient: base )
    }
    self.save
  end

  def recalculate
    self.update( total: calculate )
  end

  private

  def calculate
    pizza_items.inject(0){|sum, pit| sum + pit.total }
  end

end
