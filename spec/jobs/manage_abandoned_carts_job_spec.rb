# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ManageAbandonedCartsJob, type: :job do
  let!(:active_cart) { FactoryBot.create(:cart, last_interaction_at: 4.hours.ago) }
  let!(:abandoned_cart) { FactoryBot.create(:cart, abandoned_at: 8.days.ago) }
  let!(:recent_cart) { FactoryBot.create(:cart, last_interaction_at: 2.hours.ago) }

  describe '#perform' do
    it 'marks carts as abandoned if inactive for more than 3 hours' do
      expect { described_class.perform_now }
        .to change { active_cart.reload.abandoned_at }.from(nil).to(Time)
    end

    it 'does not mark carts as abandoned if inactive for less than 3 hours' do
      expect { described_class.perform_now }
        .not_to change { recent_cart.reload.abandoned_at }
    end

    it 'removes carts that have been abandoned for more than 7 days' do
      expect { described_class.perform_now }.to change { Cart.count }.by(-1)
    end
  end
end
