class AddSnmpCommunityToSite < ActiveRecord::Migration
  def change
    add_column :sites, :snmpcommunity, :string

  end
end
