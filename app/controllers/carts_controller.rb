# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :validate_cart_params, only: %i[create add_item remove_item]
  before_action :cart
  before_action :product, only: :create
  before_action :cart_product, only: %i[add_item remove_item]

  def create
    ActiveRecord::Base.transaction do
      add_product_to_cart
      update_cart_last_interaction
    end

    Rails.logger.info("Product #{cart_params[:product_id]} added to cart #{cart.id}")
    render json: cart_json, status: :created
  end

  def show
    render json: cart_json, status: :ok
  end

  def add_item
    return render json: { error: 'Product not found' }, status: :not_found unless cart_product

    old_quantity = cart_product.quantity
    increment_product
    update_cart_last_interaction

    Rails.logger.info("Product #{cart_params[:product_id]} quantity updated from #{old_quantity} to #{cart_product.reload.quantity} in cart #{cart.id}")
    render json: cart_json, status: :ok
  end

  def remove_item
    return render json: { error: 'Product not found' }, status: :not_found unless cart_product

    product_id = cart_product.product_id
    cart_product.destroy
    update_cart_last_interaction

    Rails.logger.info("Product #{product_id} removed from cart #{cart.id}")
    render json: cart_json, status: :ok
  rescue StandardError => e
    Rails.logger.error("Error removing item from cart: #{e.message}")
    render json: { error: 'Failed to remove item' }, status: :unprocessable_entity
  end

  private

  def validate_cart_params
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    if product_id <= 0 || quantity <= 0
      render json: { error: 'Invalid product_id or quantity' }, status: :unprocessable_entity
    end
  end

  def cart
    @cart ||= find_or_create_cart
  end

  def product
    @product ||= Product.find(cart_params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Product not found' }, status: :not_found and return
  end

  def cart_product
    @cart_product ||= cart.cart_products.find_by(product_id: cart_params[:product_id])
  end

  def add_product_to_cart
    cart.cart_products << CartProduct.new(product: product, quantity: cart_params[:quantity])
  end

  def increment_product
    cart_product.update(quantity: cart_product.quantity + cart_params[:quantity])
  end

  def update_cart_last_interaction
    cart.update(last_interaction_at: Time.current)
  end

  def find_or_create_cart
    if action_name == 'create' && session[:cart_id].nil?
      cart = Cart.create
      session[:cart_id] = cart.id

      return cart
    end

    # Validate session cart exists before querying
    return Cart.create unless session[:cart_id] && Cart.exists?(session[:cart_id])

    Cart.find(session[:cart_id])
  end

  def cart_json
    {
      cart_id: cart.id,
      products: cart_products,
      total_price: cart.total_price
    }
  end

  def cart_products
    cart.cart_products.includes(:product).map do |cart_product|
      {
        id: cart_product.product.id,
        name: cart_product.name,
        quantity: cart_product.quantity,
        unit_price: cart_product.price,
        total_price: cart_product.total_price
      }
    end
  end

  def cart_params
    {
      product_id: params[:product_id].to_i,
      quantity: params[:quantity].to_i
    }
  end
end
