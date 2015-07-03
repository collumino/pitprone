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

  def confirm_verified_order
    current_or_guest_user.address = Address.create(secure_params)
    current_or_guest_user.orders.last.buy_pizza!
    sign_out
    redirect_to :thank_you
  end

  def thank_you
  end

  private

  def secure_params
    params.require(:address).permit([:name, :firstname, :street, :city, :phone, :mobile])
  end
end
