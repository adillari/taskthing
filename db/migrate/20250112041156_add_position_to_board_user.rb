class AddPositionToBoardUser < ActiveRecord::Migration[8.0]
  def change
    add_column(:board_users, :position, :integer)
  end
end
