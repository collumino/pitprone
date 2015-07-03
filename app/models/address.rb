class Address < ActiveRecord::Base
  belongs_to :user

  validates :name, :street, :city, presence: true

end
