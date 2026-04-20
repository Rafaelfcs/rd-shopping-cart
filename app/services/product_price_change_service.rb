# frozen_string_literal: true

class ProductPriceChangeService
  def initialize(product)
    @product = product
  end

  def call
    return unless @product.saved_change_to_price?

    touch_affected_cart_products
  end

  private

  def touch_affected_cart_products
    @product.cart_products.each(&:touch)
  end
end
