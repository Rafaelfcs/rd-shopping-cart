# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let!(:cart) { FactoryBot.create(:cart) }
  let(:product) { Product.all.sample }

  let(:params) { { product_id: product.id, quantity: quantity } }
  let(:quantity) { rand(1..3) }

  let(:session) { { cart_id: cart.id } }

  describe 'POST #create' do
    subject { post :create, params: params, session: session }

    context 'when session has a cart_id' do
      it 'does not create a new cart' do
        expect { subject }.to_not change { Cart.count }
      end
    end

    context 'when session does not have a cart_id' do
      let(:session) { { cart_id: nil } }

      it 'creates a new cart' do
        expect { subject }.to change { Cart.count }.by(1)
      end
    end

    context 'when product is found' do
      it 'adds the product to the cart' do
        expect { subject }.to change { cart.cart_products.count }.by(1)
      end
    end

    context 'when product is not found' do
      let(:params) { { product_id: 0, quantity: 2 } }

      it 'does not add the product to the cart' do
        expect { subject }.to change { cart.cart_products.count }.by(0)
      end

      it 'returns not found status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
