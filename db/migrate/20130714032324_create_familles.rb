class CreateFamilles < ActiveRecord::Migration
  def change
    create_table :familles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
