class CreateSysteminstallscripts < ActiveRecord::Migration
  def change
    create_table :systeminstallscripts do |t|
      t.string :name
      t.text :script
      t.text :description
      t.integer :famille_id

      t.timestamps
    end
  end
end
