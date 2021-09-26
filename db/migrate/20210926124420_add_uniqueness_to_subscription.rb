class AddUniquenessToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_index :subscriptions, %i[user_id question_id], unique: true
  end
end
