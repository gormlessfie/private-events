class AddUniqueIndexOnColumnsEventIdAndUserIdInUsersEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :users_events, [:user_id, :event_id], unique: true
  end
end
