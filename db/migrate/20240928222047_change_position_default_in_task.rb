class ChangePositionDefaultInTask < ActiveRecord::Migration[8.0]
  def change
    change_column_default(:tasks, :position, 0)
  end
end
