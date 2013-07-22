class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :uuid
      t.string :mac
      t.integer :architecture_id
      t.integer :site_id
      t.integer :sitedestination
      t.integer :etat_id
      t.integer :system_id
      t.integer :postinstallscript_id
      t.integer :systeminstallscript_id
      t.boolean :usedhcp
      t.boolean :useproxy
      t.string :currentaddress
      t.string :destinationaddress
      t.text :information
      t.timestamps
    end
  end
end
