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

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      head :no_content
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
