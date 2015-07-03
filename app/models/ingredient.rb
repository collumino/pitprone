class Ingredient < ActiveRecord::Base
  belongs_to :property
  has_many :pizza_items

  scope :vegan, ->  () { where( vegan: true ) }
  scope :default, ->  () { where( is_default: true ) }


  class << self
    def addon_free
      Ingredient.all.select{|ingredient| ingredient.owns_add_ons.empty? }
    end

    def group_by_category
      Ingredient.all.reject{|ingr| ingr.is_default }.inject({}){|hash, ingr|
        hash[ingr.category] = [] unless hash[ingr.category]
        hash[ingr.category] << ingr
        hash
      }
    end
  end

  def owns_add_ons
    add_on_list.select{|add| property.send(add) }
  end

  def tags(collect = [])
    collect << 'vegan' if self.vegan
    collect << 'owns_addon' if self.owns_add_ons.any?
    collect
  end

  def sibling
    index = [Ingredient.group_by_category.keys.index(self.category), Ingredient.group_by_category.values[3].index(self)].join('-')
    "item_#{index}"
  end

  protected

  def add_on_list
    [:sugar, :antioxidant, :dye, :conserve , :phophate]
  end



end
