# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/carts', type: :request do
  pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}" # rubocop:disable Layout/LineLength
  describe 'POST /add_items' do
    let(:cart) { Cart.create }
    let(:product) { Product.create(name: 'Test Product', price: 10.0) }
    let!(:cart_item) { CartItem.create(cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/cart/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      xit 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
