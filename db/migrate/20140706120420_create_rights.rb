class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.references :left
      t.references :parent
      t.string :name

      t.timestamps
    end
  end
end
