class ChangeEventDateColumnInEvents < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :event_date, :datetime
  end
end
