class Admin::PizzasController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_pizza, only: [:show, :update, :destroy]

  # GET /pizzas
  # GET /pizzas.json
  def index
    @pizzas = Pizza.all

    render json: @pizzas
  end

  # GET /pizzas/1
  # GET /pizzas/1.json
  def show
    render json: @pizza
  end

  # POST /pizzas
  # POST /pizzas.json
  def create
    @pizza = Pizza.new(pizza_params)

    if @pizza.save
      render json: @pizza, status: :created, location: @pizza
    else
      render json: @pizza.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pizzas/1
  # PATCH/PUT /pizzas/1.json
  def update
    @pizza = Pizza.find(params[:id])

    if @pizza.update(pizza_params)
      head :no_content
    else
      render json: @pizza.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pizzas/1
  # DELETE /pizzas/1.json
  def destroy
    @pizza.destroy

    head :no_content
  end

  private

    def set_pizza
      @pizza = Pizza.find(params[:id])
    end

    def pizza_params
      params.require(:pizza).permit(:order_id, :total)
    end
end
