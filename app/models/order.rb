class Order < ActiveRecord::Base
  include AASM
  belongs_to :user
  has_many :pizzas, dependent: :destroy

  attr_accessor :next_action

  aasm :column => 'state' do
    state :created, :initial => true
    state :customizing
    state :waiting_for_process
    state :waiting_for_delivery
    state :on_delivery
    state :finished

    event :build_pizza do
      transitions :from => :created, :to => :customizing
    end

    event :buy_pizza do
      transitions :from => :customizing, :to => :waiting_for_process, :if => :valid_order?
    end

    event :bake_pizza do
      transitions :from => :waiting_for_process, :to => :waiting_for_delivery
    end

    event :deliver_pizza do
      transitions :from => :waiting_for_delivery, :to => :finished
    end

  end


  rails_admin do

    configure :pdf_is_avaliable do
      pretty_value do
        util = bindings[:object]
        if util.waiting_for_delivery? || util.waiting_for_process? || util.finished?
          "<a href='order/#{util.id}/pdf'>pdf</a>".html_safe
        else
          '-'
        end
      end
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    configure :next_action do
      pretty_value do
        util = bindings[:object]
        case
          when util.waiting_for_process?
            "<a href='order/#{util.id}/process'>Backen</a>".html_safe
          when util.waiting_for_delivery?
            "<a href='order/#{util.id}/deliver'>Liefern</a>".html_safe
          when util.finished?
            "abgeschlossen".html_safe
          else
            '-'

        end
      end
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end

    list do
      field :user
      field :total
      field :pdf_is_avaliable
      field :state
      field :next_action
      field :created_at
    end
  end

  def valid_order?
    self.total > 0 && self.user.present? && self.user.address.present? && self.user.address.valid?
  end

  def missing_conditions
    return 'leere Bestellung' if self.total == 0
    return 'kein Benutzer' unless self.user.present?
    return 'leere Adresse' unless self.user.address.present?
    return self.user.address.errors unless self.user.address.valid?
    'unzulässiger Statusübergang'
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

  def pdf_url
    File.join( PdfGenerator::BASE_PATH , "#{self.id}" , self.pdf_is_avaliable )
  end
  private

  def calculate
    pizzas.inject(0){|sum, pizza| sum + pizza.total }
  end

end
