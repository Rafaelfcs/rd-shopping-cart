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
class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  after_touch :update_total_price

  has_many :cart_products, dependent: :destroy

  scope :active, -> { where(abandoned_at: nil) }
  scope :abandoned, -> { where.not(abandoned_at: nil) }
  scope :to_be_deleted, -> { where('abandoned_at < ?', 7.days.ago) }
  scope :to_be_abandoned, -> { where('last_interaction_at < ?', 3.hours.ago) }

  def mark_as_abandoned
    update(abandoned_at: Time.current) if last_interaction_at < 3.hours.ago
  end

  def remove_if_abandoned
    destroy if abandoned_at < 7.days.ago
  end

  private

  def update_total_price
    new_total_price = cart_products.map(&:total_price).sum

    update_column(:total_price, new_total_price) if total_price != new_total_price
  end
end
