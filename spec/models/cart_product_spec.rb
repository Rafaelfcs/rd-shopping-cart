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
require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe 'validations' do
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:price).to(:product) }
    it { is_expected.to delegate_method(:name).to(:product) }
  end

  describe 'instance methods' do
    describe '#total_price' do
      let(:cart_product) { FactoryBot.create(:cart_product, quantity: 2) }
      let(:product) { cart_product.product }

      it 'returns the total price of the cart product' do
        expect(cart_product.total_price).to eq(product.price * cart_product.quantity)
      end
    end
  end
end
