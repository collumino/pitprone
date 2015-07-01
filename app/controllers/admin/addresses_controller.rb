class Admin::AddressesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_address, only: [:show, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = Address.all

    render json: @addresses
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    render json: @address
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)

    if @address.save
      render json: @address, status: :created, location: @address
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    @address = Address.find(params[:id])

    if @address.update(address_params)
      head :no_content
    else
      render json: @address.errors, status: :unprocessable_entity
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy

    head :no_content
  end

  private

    def set_address
      @address = Address.find(params[:id])
    end

    def address_params
      params.require(:address).permit(:user_id, :name, :firstname, :street, :city, :phone, :mobile)
    end
end
