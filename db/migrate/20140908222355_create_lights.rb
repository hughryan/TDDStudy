class CreateLights < ActiveRecord::Migration
  def change
    create_table :lights do |t|
      t.references :phase, index: true
      t.references :phase, index: true
      t.string :light_color
      t.integer :git_tag
      t.integer :total_edited_line_count
      t.integer :production_edited_line_count
      t.integer :test_edited_line_count
      t.integer :total_test_method_count
      t.integer :total_test_run_fail_count
      t.integer :seconds_since_last_light
      t.float :statement_coverage
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count

      t.timestamps
    end
  end
end
