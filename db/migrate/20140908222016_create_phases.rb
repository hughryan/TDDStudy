class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.references :cycle, index: true
      t.string :tdd_color
      t.integer :seconds_in_phase
      t.integer :total_edit_count
      t.integer :production_edit_count
      t.integer :test_edit_count
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.integer :total_line_change_count
      t.integer :production_line_change_count
      t.integer :test_line_change_count

      t.timestamps
    end
  end
end
