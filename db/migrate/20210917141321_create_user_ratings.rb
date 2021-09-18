class CreateUserRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :mark, null: false
      t.belongs_to :rateable, polymorphic: true

      t.index [:user_id, :rateable_id, :rateable_type], unique: true

      t.timestamps
    end
  end
end
