class VisitorsController < ApplicationController

  def index
    @user = current_or_guest_user
    @order = @user.orders.last || Order.new()
    @ingredients = Ingredient.all.reject{|ingr| ingr.is_default }.inject({}){|hash, ingr|
      hash[ingr.category] = [] unless hash[ingr.category]
      hash[ingr.category] << ingr
      hash
    }
  end

end
