class CreateLefts < ActiveRecord::Migration
  def change
    create_table :lefts do |t|
      t.integer :section
      t.integer :num
      t.integer :price
      t.integer :amount
      t.integer :lock_version, :null => false, :default => 0

      t.timestamps
    end
  end
end
