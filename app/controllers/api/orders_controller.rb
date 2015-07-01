class Api::OrdersController < ActionController::API
  before_filter :authenticate_order_from_token!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    render json: @orders
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    render json: @order
  end

  # POST /orders
  # POST /orders.json
  def create
    Pizza.transaction do
      pizza = Pizza.new( size_factor: Pizza.weight(params[:size]) )
      @order.pizzas << pizza if pizza.prepare
      if @order.save
        render json: pizza.size_factor, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  end


  def add_item
    selected_ingredient = Ingredient.find_by_name(params[:name])
    @order.pizza_in_progress.pizza_items << PizzaItem.new({quantity: 1, ingredient: selected_ingredient})
    if @order.save
      render json:  { added: selected_ingredient, amount: @order.pizza_in_progress.pizza_items.count - Ingredient.default.count }.to_json, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def remove_item
    selected_ingredient = Ingredient.find_by_name(params[:name])
    if @order.pizza_in_progress.pizza_items.select{|pit| pit.ingredient == selected_ingredient }.last.delete
      render json:  { deleted: selected_ingredient, amount: @order.pizza_in_progress.pizza_items.count - Ingredient.default.count}.to_json, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    pizza = @order.pizza_in_progress
    if pizza.update(size_factor: Pizza.weight(params[:size]))
      # head :no_content
      render json: pizza.size_factor, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy

    head :no_content
  end

  private

  def authenticate_order_from_token!
    user_email = request.headers['HTTP_X_USER'] || params[:user_email]
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.

    if user && Devise.secure_compare(user.authentication_token, request.headers['HTTP_X_TOKEN'] || params[:user_token])
      sign_in user, store: false
      @order = user.orders.last if user.orders.any?
      @order ||= Order.new( user: user )
    end
  end

end