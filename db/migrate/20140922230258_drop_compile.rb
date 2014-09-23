class DropCompile < ActiveRecord::Migration
	def change
		drop_table :compile
	end

	create_table :compiles do |c|
		c.references :session, index: true
		c.string :light_color
		c.integer :git_tag
		c.integer :total_edited_line_count
		c.integer :production_edited_line_count
		c.integer :test_edited_line_count
		c.integer :total_test_method_count
		c.integer :total_test_run_fail_count
		c.integer :seconds_since_last_light
		c.float :statement_coverage
		c.integer :total_sloc_count
		c.integer :production_sloc_count
		c.integer :test_sloc_count

		c.timestamps
	end
end
