class VisitorsController < ApplicationController

  def index
    @user = current_or_guest_user
    @order = @user.orders.last || Order.new()
    @ingredients = Ingredient.group_by_category
  end

  def destroy_order
    current_or_guest_user.orders.last.destroy
    redirect_to :root
  end
end
