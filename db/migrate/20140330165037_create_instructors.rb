class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :name
      t.string :class
      t.string :major

      t.timestamps
    end
  end
end
