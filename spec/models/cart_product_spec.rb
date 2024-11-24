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
#
require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:product) }
  end
end
