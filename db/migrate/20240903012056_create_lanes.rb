class CreateLanes < ActiveRecord::Migration[8.0]
  def change
    create_table(:lanes) do |t|
      t.references(:board, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
