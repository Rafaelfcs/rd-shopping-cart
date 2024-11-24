# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :cart
  before_action :product, only: :create
  before_action :cart_product, only: %i[add_item remove_item]

  def create
    add_product_to_cart

    render json: cart_json, status: :created
  end

  def show
    render json: cart_json, status: :ok
  end

  def add_item
    return render json: { error: 'Product not found' }, status: :not_found unless cart_product

    cart_product.update(quantity: cart_product.quantity + cart_params[:quantity].to_i)

    render json: cart_json, status: :ok
  end

  def remove_item
    return render json: { error: 'Product not found' }, status: :not_found unless cart_product

    cart_product.destroy

    render json: cart_json, status: :ok
  end

  private

  def cart
    @cart ||= find_or_create_cart
  end

  def product
    @product ||= Product.find(cart_params[:product_id])
  end

  def cart_product
    @cart_product ||= cart.cart_products.find_by(product_id: cart_params[:product_id])
  end

  def add_product_to_cart
    cart.cart_products << CartProduct.new(product: product, quantity: cart_params[:quantity])
  end

  def find_or_create_cart
    if action_name == 'create' && session[:cart_id].nil?
      cart = Cart.create
      session[:cart_id] = cart.id

      return cart
    end

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
    cart.cart_products.map do |cart_product|
      {
        id: cart_product.product.id,
        name: cart_product.name,
        quantity: cart_product.quantity,
        unity_price: cart_product.price,
        total_price: cart_product.total_price
      }
    end
  end

  def cart_params
    params.permit(:product_id, :quantity)
  end
end
