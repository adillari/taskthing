class AddPositionToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :position, :integer
  end
end
