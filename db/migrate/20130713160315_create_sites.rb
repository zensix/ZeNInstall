class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :dnssrv
      t.string :dnsdomain
      t.string :netmask
      t.string :gateway
      t.string :puppetsrv
      t.string :proxyurl
      t.string :ntpsrv
      t.text :description

      t.timestamps
    end
  end
end
