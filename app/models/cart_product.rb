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
#
class CartProduct < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :product

  delegate :price, to: :product
end
