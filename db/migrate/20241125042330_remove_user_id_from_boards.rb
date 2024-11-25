class RemoveUserIdFromBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :user_id, :integer
  end
end
