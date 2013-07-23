class CreateProjectionscripts < ActiveRecord::Migration
  def change
    create_table :projectionscripts do |t|
      t.string :name
      t.text :script
      t.text :description

      t.timestamps
    end
  end
end
