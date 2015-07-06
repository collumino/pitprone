class Api::PizzasController < ActionController::API
  before_filter :authenticate_order_from_token!

  # shows current pizza with all items
  def index
    render json: { size: I18n.t(@order.pizza_in_progress.size || '?') , costs: con2curr( @order.pizza_in_progress.total ), items: reduced_pizza_items }.to_json, status: :ok
  end

  # creating pizza
  def create
    Pizza.transaction do
      pizza = Pizza.new( size_factor: Pizza.weight(params[:size]) )
      @order.pizzas << pizza if pizza.prepare
      if @order.valid?
        @order.recalculate
        render json: { size: I18n.t(pizza.size) , costs: @order.sign_price }.to_json, status: :created
      else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  end

  def add_item
    selected_ingredient = Ingredient.find_by_name(params[:name])
    @order.pizza_in_progress.pizza_items << PizzaItem.new({quantity: 1, ingredient: selected_ingredient})
    if @order.valid?
      @order.build_pizza! if @order.may_build_pizza?
      @order.recalculate
      render json:  { costs: @order.sign_price , added: selected_ingredient, amount: @order.pizza_in_progress.pizza_items.count - Ingredient.default.count }.to_json, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def remove_item
    selected_ingredient = Ingredient.find_by_name(params[:name])
    if @order.pizza_in_progress.pizza_items.select{|pit| pit.ingredient == selected_ingredient }.last.delete
      @order.recalculate
      render json:  { costs: @order.sign_price , deleted: selected_ingredient, amount: @order.pizza_in_progress.pizza_items.count - Ingredient.default.count}.to_json, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # changes the size of pizza
  def update
    pizza = @order.pizza_in_progress
    if pizza.update(size_factor: Pizza.weight(params[:size]))
      @order.recalculate
      # head :no_content
      render json: { size: I18n.t(pizza.size) , costs: @order.sign_price }.to_json, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def check_orderable
    @order.build_pizza! unless @order.may_buy_pizza?
    return head :accepted if @order.may_buy_pizza?
    head :conflict
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

  def reduced_pizza_items
    @order.pizza_in_progress.pizza_items.collect{|line|
      { amount: line.quantity, describer: line.ingredient.name, price: con2curr(line.total) }
    }
  end

  def con2curr(price)
    price ||= 0.0
    "#{sprintf('%.02f', price.round(2) )} CHF"
  end

end
