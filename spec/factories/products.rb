# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :decimal(17, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end
