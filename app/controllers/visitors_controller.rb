require 'pdf_generator'

class VisitorsController < ApplicationController
  before_filter :get_actual_order, except: [:index, :download, :finish, :start ]

  def index
    @user = current_or_guest_user
    @order = @user.orders.last || Order.new()
    @ingredients = Ingredient.group_by_category
  end

  def destroy_order
    @order.destroy
    redirect_to :root
  end

  def confirm_verified_order
    current_or_guest_user.address = Address.create(secure_params)
    @order.update( pdf_is_avaliable: PdfGenerator.create_doc(@order))
    @order.buy_pizza!
    reset_session
    redirect_to :thank_you
  end

  def thank_you
  end

  # faked admin methods
  def start
    order = Order.find(params[:id])
    if order.pdf_is_avaliable.present?
      order.bake_pizza!
      redirect_to '/supervizor/order'
    else
      head :no_content
    end
  end

  def download
    order = Order.find(params[:id])
    if order.pdf_is_avaliable.present?
      send_file order.pdf_url
    else
      head :no_content
    end
  end

  def finish
    order = Order.find(params[:id])
    if order.pdf_is_avaliable.present?
      order.deliver_pizza!
      redirect_to '/supervizor/order'
    else
      head :no_content
    end
  end


  private

  def get_actual_order
    @order = current_or_guest_user.orders.last
  end

  def secure_params
    params.require(:address).permit([:name, :firstname, :street, :city, :phone, :mobile])
  end
end
