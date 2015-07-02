class Order < ActiveRecord::Base
  include AASM
  belongs_to :user
  has_many :pizzas, dependent: :destroy

  aasm :column => 'state' do
    state :created, :initial => true
    state :customized
    state :checked_out
    state :in_process
    state :on_delivery
    state :finsihed

    event :build_pizza do
      transitions :from => :created, :to => :customized
    end

    event :buy_pizza do
      transitions :from => :customized, :to => :checked_out, :if => :valid_order?
    end

    event :bake_pizza do
      transitions :from => :checked_out, :to => :in_process
    end

    event :deliver_pizza do
      transitions :from => :in_process, :to => :on_delivery
    end

    event :archive_order do
      transitions :from => :on_delivery, :to => :finsihed
    end
  end


  def valid_order?
    self.total > 0 && current_user && current_user.address.valid?
  end

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
