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
FactoryBot.define do
  factory :cart_product do
    quantity { Faker::Number.within(range: 1..3) }

    cart
    product
  end
end
