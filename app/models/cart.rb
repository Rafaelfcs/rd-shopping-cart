# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id          :bigint           not null, primary key
#  total_price :decimal(17, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  has_many :cart_products

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
end
