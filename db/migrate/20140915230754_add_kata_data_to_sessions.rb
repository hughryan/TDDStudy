class AddKataDataToSessions < ActiveRecord::Migration
  def change
<<<<<<< HEAD:db/migrate/20140908221118_create_kata.rb
    create_table :katas do |t|
=======
  	 change_table :sessions do |t|
>>>>>>> fe03b873fd8fc354d3cd13da9a0aea850cffaecf:db/migrate/20140915230754_add_kata_data_to_sessions.rb
      t.string :kata_name
      t.string :cyberdojo_id
      t.string :language_framework
      t.string :path
  end
  end
end
