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
class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  after_touch :update_total_price

  has_many :cart_products, dependent: :destroy

  private

  def update_total_price
    new_total_price = cart_products.map(&:price).sum

    update_column(:total_price, new_total_price) if total_price != new_total_price
  end

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end
