class CreateEtats < ActiveRecord::Migration
  def change
    create_table :etats do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
