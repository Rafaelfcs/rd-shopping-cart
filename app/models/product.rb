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
class Product < ApplicationRecord
  validates_presence_of :name, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0

  has_many :cart_products, dependent: :destroy

  after_save :update_cart_products

  private

  def update_cart_products
    cart_products.each(&:touch) if saved_change_to_price?
  end
end
