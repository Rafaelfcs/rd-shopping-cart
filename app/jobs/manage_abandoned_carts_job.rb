# frozen_string_literal: true

class ManageAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    mark_abandoned_carts
    remove_old_abandoned_carts
  end

  private

  def mark_abandoned_carts
    Cart.active.to_be_abandoned.find_each(&:mark_as_abandoned)
  end

  def remove_old_abandoned_carts
    Cart.to_be_deleted.find_each(&:remove_if_abandoned)
  end
end
