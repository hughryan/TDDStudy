class FixPluralError < ActiveRecord::Migration
	def change
		remove_reference :compiles, :sessions , index: true
		add_reference :compiles, :session , index: true
	end
end
