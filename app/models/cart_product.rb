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
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  belongs_to :cart, touch: true
  belongs_to :product

  delegate :price, :name, to: :product

  def total_price
    price * quantity
  end
end
