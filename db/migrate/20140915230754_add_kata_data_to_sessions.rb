class AddKataDataToSessions < ActiveRecord::Migration
  def change
  	 change_table :sessions do |t|
      t.string :kata_name
      t.string :cyberdojo_id
      t.string :language_framework
      t.string :path
  end
  end
end
