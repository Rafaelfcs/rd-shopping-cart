# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id          :bigint           not null, primary key
#  total_price :decimal(17, 2)   default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :cart do
    trait :with_products do
      after(:create) do |cart|
        create_list(:cart_product, 3, cart: cart)
      end
    end
  end
end
