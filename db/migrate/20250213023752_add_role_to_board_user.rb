class AddRoleToBoardUser < ActiveRecord::Migration[8.0]
  def change
    add_column(:board_users, :role, :string)
  end
end
