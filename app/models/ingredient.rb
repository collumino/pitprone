class Ingredient < ActiveRecord::Base
  belongs_to :property
  has_many :pizza_items

  scope :vegan, ->  () { where( vegan: true ) }
  scope :default, ->  () { where( is_default: true ) }

end
