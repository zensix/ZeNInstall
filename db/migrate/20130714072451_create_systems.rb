class CreateSystems < ActiveRecord::Migration
  def change
    create_table :systems do |t|
      t.string :name
      t.integer :architecture_id
      t.integer :famille_id
      t.string :kernelpath
      t.string :initrdpath
      t.string :repository
      t.integer :ipxescript_id
      t.text :description

      t.timestamps
    end
  end
end
