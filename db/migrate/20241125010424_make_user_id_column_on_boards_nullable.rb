class MakeUserIdColumnOnBoardsNullable < ActiveRecord::Migration[8.0]
  def change
    change_column_null(:boards, :user_id, true)
  end
end
