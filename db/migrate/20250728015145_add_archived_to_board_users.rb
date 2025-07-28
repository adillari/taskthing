class AddArchivedToBoardUsers < ActiveRecord::Migration[8.0]
  def change
    add_column(:board_users, :archived, :boolean, default: false, null: false)
  end
end
