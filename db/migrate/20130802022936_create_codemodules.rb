class CreateCodemodules < ActiveRecord::Migration
  def change
    create_table :codemodules do |t|
      t.string :name
      t.text :code
      t.text :description

      t.timestamps
    end
  end
end
