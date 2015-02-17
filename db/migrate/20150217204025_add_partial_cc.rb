class AddPartialCc < ActiveRecord::Migration
  def change
    add_column :sessions, :test_cycomatic_complexity, :float
    add_column :sessions, :production_cycomatic_complexity, :float
  end
end
