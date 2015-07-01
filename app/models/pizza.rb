class Pizza < ActiveRecord::Base
  has_many :pizza_items, -> { order("#{PizzaItem.table_name}.created_at ASC") }, dependent: :destroy
  belongs_to :order

  class << self
    def size
      { 'small' => 25, 'medium' => 28, 'big' => 32 }
    end

    def weight(size)
      { 'small' => 1.0, 'medium' => 1.25, 'big' => 1.65 }[size]
    end

    def size_name(value)
      { 'small' => 1.0, 'medium' => 1.25, 'big' => 1.65 }.invert[value]
    end

  end


  def prepare
    Ingredient.default.each{|base|
      self.pizza_items << PizzaItem.create( quantity: 1, ingredient: base )
    }
    self.save
  end


end
