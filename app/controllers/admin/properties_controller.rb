class Admin::PropertiesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_property, only: [:show, :update, :destroy]

  # GET /properties
  # GET /properties.json
  def index
    @properties = Property.all

    render json: @properties
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    render json: @property
  end

  # POST /properties
  # POST /properties.json
  def create
    @property = Property.new(property_params)

    if @property.save
      render json: @property, status: :created, location: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /properties/1
  # PATCH/PUT /properties/1.json
  def update
    @property = Property.find(params[:id])

    if @property.update(property_params)
      head :no_content
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  # DELETE /properties/1
  # DELETE /properties/1.json
  def destroy
    @property.destroy

    head :no_content
  end

  private

    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:sugar, :antioxidant, :dye, :conserve, :phophate)
    end
end
