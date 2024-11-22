class AddNameToLanes < ActiveRecord::Migration[8.0]
  def change
    add_column(:lanes, :name, :string)
  end
end
