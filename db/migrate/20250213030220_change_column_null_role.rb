class ChangeColumnNullRole < ActiveRecord::Migration[8.0]
  def change
    change_column_null(:board_users, :role, false)
  end
end
