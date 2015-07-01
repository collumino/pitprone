class Ingredient < ActiveRecord::Base
  belongs_to :property
  has_many :pizza_items

  scope :vegan, ->  () { where( vegan: true ) }
  scope :default, ->  () { where( is_default: true ) }


  class << self
    def addon_free
      Ingredient.all.select{|ingredient| ingredient.owns_add_ons.empty? }
    end
  end

  def owns_add_ons
    add_on_list.select{|add| property.send(add) }
  end

  protected

  def add_on_list
    [:sugar, :antioxidant, :dye, :conserve , :phophate]
  end

end
