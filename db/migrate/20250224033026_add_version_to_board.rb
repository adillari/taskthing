class AddVersionToBoard < ActiveRecord::Migration[8.0]
  def change
    add_column(:boards, :version, :integer, default: 1, null: false)
  end
end
