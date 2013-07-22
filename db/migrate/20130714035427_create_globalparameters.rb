class CreateGlobalparameters < ActiveRecord::Migration
  def change
    create_table :globalparameters do |t|
      t.string :name
      t.string :value
      t.text :description

      t.timestamps
    end
  end
end
