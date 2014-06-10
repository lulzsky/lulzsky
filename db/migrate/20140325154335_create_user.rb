class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :oasid
      t.string :oaspw
      t.string :fbuid
      t.text :maindump
      t.text :schedule
    end
  end
end
