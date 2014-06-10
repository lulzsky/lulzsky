class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :usrid
      t.integer :insid
      t.integer :score

      t.timestamps
    end
  end
end
