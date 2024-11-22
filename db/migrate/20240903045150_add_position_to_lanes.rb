class AddPositionToLanes < ActiveRecord::Migration[8.0]
  def change
    add_column(:lanes, :position, :integer)
  end
end
