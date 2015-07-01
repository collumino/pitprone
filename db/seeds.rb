require 'yaml'

user = User.create! :name => 'Admin', :email => 'admin@pizza.ch', :password => '123123123', :password_confirmation => '123123123'
# user.confirm!

data = YAML.load_file('db/zutaten.yml')
data.each{|key,values|
  values.each{|value|
    value.reject!{|k,v| k.match(%r{placeholder}).present? }
    properties = value.delete('properties')

    ingredient= Ingredient.new(value)
    ingredient.property = ( Property.where(properties).any? ? Property.where(properties).first : Property.create(properties) )
    ingredient.save
  }
}

user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

