class Pizza < ActiveRecord::Base
  has_many :pizza_items, -> { order("#{PizzaItem.table_name}.created_at ASC") }, dependent: :destroy
  belongs_to :order

  rails_admin do
    configure :size_factor do
      pretty_value do
        util = bindings[:object]
        %{ #{I18n.t(util.size)} }.html_safe
      end
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    configure :created_at do
      pretty_value do
        util = bindings[:object]
        %{ #{I18n.l(util.created_at)} }.html_safe
      end
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    configure :total do
        pretty_value do
          util = bindings[:object]
          %{ #{sprintf("%.02f", util.total)} CHF}.html_safe
        end
        read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    configure :state do
        pretty_value do
          util = bindings[:object]
          %{ #{util.order.state}} .html_safe
        end
        formatted_value do

        end
        read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    list do
      field :order
      field :size_factor
      field :total
      field :state
      field :created_at
    end
  end

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
