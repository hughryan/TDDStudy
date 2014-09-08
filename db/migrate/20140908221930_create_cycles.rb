class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.references :session, index: true
      t.integer :total_edit_count
      t.integer :production_edit_count
      t.integer :test_edit_count
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.float :statement_coverage
      t.integer :cyclomatic_complexity
      t.boolean :valid_tdd
      t.integer :cycle_position

      t.timestamps
    end
  end
end
