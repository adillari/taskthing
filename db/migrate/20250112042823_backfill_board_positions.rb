class BackfillBoardPositions < ActiveRecord::Migration[8.0]
  def change
    User.includes(:board_users).find_each do |user|
      user.board_users.order(:created_at).each_with_index do |board_user, position|
        board_user.update(position:)
      end
    end
  end
end
