class MigrateBoardOwnershipToBoardUsers < ActiveRecord::Migration[8.0]
  def change
    Board.find_each do |board|
      board_user = board.board_users.new
      board_user.user_id = board.user_id
      board_user.save!
    end
  end
end
