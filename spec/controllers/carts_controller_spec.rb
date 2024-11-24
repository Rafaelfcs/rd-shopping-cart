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

  describe 'GET #show' do
    subject { get :show, session: session }

    context 'when cart is found' do
      let!(:cart_product) do
        FactoryBot.create(:cart_product, cart: cart, product: product, quantity: 1)
      end
      let(:product) { FactoryBot.create(:product) }

      let(:expected_json) do
        {
          cart_id: cart.id,
          products: [
            {
              id: product.id,
              name: product.name,
              quantity: cart_product.quantity,
              unity_price: product.price,
              total_price: cart_product.total_price
            }
          ],
          total_price: cart.total_price
        }
      end
      it 'returns the cart' do
        subject

        expect(response.body).to eq(expected_json.to_json)
      end
    end

    context 'when cart is not found' do
      let(:session) { { cart_id: 0 } }

      it 'returns not found status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #add_item' do
    subject { post :add_item, params: params, session: session }

    context 'when product is found on cart' do
      let!(:cart_product) do
        FactoryBot.create(:cart_product, cart: cart, product: product, quantity: 1)
      end

      it 'increases the quantity of the product' do
        expect { subject }.to change { cart_product.reload.quantity }.by(quantity)
      end
    end

    context 'when product is not found on cart' do
      let(:params) { { product_id: 0, quantity: 2 } }

      it 'does not increase the quantity of the product' do
        expect { subject }.to change { cart.cart_products.count }.by(0)
      end

      it 'returns not found status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #remove_item' do
    subject { delete :remove_item, params: params, session: session }

    context 'when product is found on cart' do
      let!(:cart_product) do
        FactoryBot.create(:cart_product, cart: cart, product: product, quantity: 1)
      end

      it 'remove the product from the cart' do
        expect { subject }.to change { cart.cart_products.count }.by(-1)
      end
    end

    context 'when product is not found on cart' do
      let(:params) { { product_id: 0, quantity: 2 } }

      it 'does not remove the product from the cart' do
        expect { subject }.to change { cart.cart_products.count }.by(0)
      end

      it 'returns not found status' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
