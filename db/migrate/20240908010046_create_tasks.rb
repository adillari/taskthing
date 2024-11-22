class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table(:tasks) do |t|
      t.references(:lane, null: false, foreign_key: true)

      t.timestamps
    end
  end
end
