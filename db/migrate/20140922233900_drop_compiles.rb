class DropCompiles < ActiveRecord::Migration
	def change
		drop_table :compiles
	end
end
