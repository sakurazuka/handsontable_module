class CreateCenters < ActiveRecord::Migration
  def change
    create_table :centers do |t|
      t.references :left
      t.string :code

      t.timestamps
    end
  end
end
