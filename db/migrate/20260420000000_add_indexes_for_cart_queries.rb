# frozen_string_literal: true

class AddIndexesForCartQueries < ActiveRecord::Migration[7.1]
  def change
    add_index :carts, :abandoned_at
    add_index :carts, :last_interaction_at
  end
end
