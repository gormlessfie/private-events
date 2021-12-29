class AddDefaultOptionToUsernameInUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :username, from: nil, to: ''
  end
end
