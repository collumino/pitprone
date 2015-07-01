class Admin::PizzaItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_pizza_item, only: [:show, :update, :destroy]

  # GET /pizza_items
  # GET /pizza_items.json
  def index
    @pizza_items = PizzaItem.all

    render json: @pizza_items
  end

  # GET /pizza_items/1
  # GET /pizza_items/1.json
  def show
    render json: @pizza_item
  end

  # POST /pizza_items
  # POST /pizza_items.json
  def create
    @pizza_item = PizzaItem.new(pizza_item_params)

    if @pizza_item.save
      render json: @pizza_item, status: :created, location: @pizza_item
    else
      render json: @pizza_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pizza_items/1
  # PATCH/PUT /pizza_items/1.json
  def update
    @pizza_item = PizzaItem.find(params[:id])

    if @pizza_item.update(pizza_item_params)
      head :no_content
    else
      render json: @pizza_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pizza_items/1
  # DELETE /pizza_items/1.json
  def destroy
    @pizza_item.destroy

    head :no_content
  end

  private

    def set_pizza_item
      @pizza_item = PizzaItem.find(params[:id])
    end

    def pizza_item_params
      params.require(:pizza_item).permit(:pizza_id, :ingredient_id, :quantity, :total)
    end
end
