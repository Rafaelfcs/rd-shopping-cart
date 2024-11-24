# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :cart
  before_action :product, only: :create

  def create
    add_product_to_cart
  end

  private

  def cart
    @cart ||= find_or_create_cart
  end

  def product
    @product ||= Product.find(cart_params[:product_id])
  end

  def add_product_to_cart
    cart.cart_products << CartProduct.new(product: product, quantity: cart_params[:quantity])
  end

  def find_or_create_cart
    if session[:cart_id]
      Cart.find(session[:cart_id])
    else
      cart = Cart.create
      session[:cart_id] = cart.id

      cart
    end
  end

  def cart_params
    params.permit(:product_id, :quantity)
  end

  # Overriding ApplicationController method
  def record_not_found
    render json: { error: 'Product not found' }, status: :not_found
  end
end
