class CreateArchitectures < ActiveRecord::Migration
  def change
    create_table :architectures do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
