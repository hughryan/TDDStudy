class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :kata_name
      t.string :cyberdojo_id
      t.string :language_framework
      t.string :path
      t.string   :avatar
      t.datetime :start_date
      t.integer :computed_time_secs
      t.integer :total_light_count
      t.integer :red_light_count
      t.integer :green_light_count
      t.integer :amber_light_count
      t.integer :max_consecutive_red_chain_length
      t.integer :total_sloc_count
      t.integer :production_sloc_count
      t.integer :test_sloc_count
      t.integer :total_edited_line_count
      t.integer :production_edited_line_count
      t.integer :test_edited_line_count
      t.integer :final_test_method_count
      t.integer :cumulative_test_run_count
      t.integer :cumulative_test_fail_count
      t.integer :final_cyclomatic_complexity
      t.float :final_branch_coverage
      t.float :final_statement_coverage
      t.integer :total_cycle_count
      t.string :final_light_color
      t.float :tdd_score

      t.timestamps
    end
  end
end
