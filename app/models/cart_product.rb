# frozen_string_literal: true

# == Schema Information
#
# Table name: cart_products
#
#  id         :bigint           not null, primary key
#  cart_id    :bigint           not null
#  product_id :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quantity   :integer
#
class CartProduct < ApplicationRecord
  # Maximum quantity to prevent overflow
  MAX_QUANTITY = 999_999

  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: MAX_QUANTITY }

  belongs_to :cart, touch: true
  belongs_to :product

  delegate :price, :name, to: :product

  def total_price
    (price * quantity).round(2)
  end
end
