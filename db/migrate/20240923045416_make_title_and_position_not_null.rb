class MakeTitleAndPositionNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :boards, :title, false
    change_column_null :tasks, :title, false
    change_column_null :lanes, :name, false
    change_column_null :tasks, :position, false
    change_column_null :lanes, :position, false
  end
end
