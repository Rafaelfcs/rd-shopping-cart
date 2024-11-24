# frozen_string_literal: true

# == Schema Information
#
# Table name: carts
#
#  id                  :bigint           not null, primary key
#  total_price         :decimal(17, 2)   default(0.0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  abandoned_at        :datetime
#  last_interaction_at :datetime
#
require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:cart_products) }
  end

  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include('must be greater than or equal to 0')
    end
  end

  describe 'mark_as_abandoned' do
    let(:cart) { FactoryBot.create(:cart) }

    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      cart.update(last_interaction_at: 3.hours.ago)
      expect { cart.mark_as_abandoned }.to change { cart.abandoned_at }.from(nil).to(Time)
    end
  end

  describe 'remove_if_abandoned' do
    let!(:cart) { FactoryBot.create(:cart, :abandoned) }

    it 'removes the shopping cart if abandoned for a certain time' do
      expect { cart.remove_if_abandoned }.to change { Cart.count }.by(-1)
    end
  end
end
