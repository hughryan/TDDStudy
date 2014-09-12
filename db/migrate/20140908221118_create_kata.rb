class CreateKata < ActiveRecord::Migration
  def change
    create_table :katas do |t|
      t.string :kata_name
      t.string :cyberdojo_id
      t.string :language_framework
      t.integer :session_count
      t.string :path

      t.timestamps
    end
  end
end
