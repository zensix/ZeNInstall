class AddProjectionscriptToFamille < ActiveRecord::Migration
  def change
    add_column :familles, :script, :integer

  end
end
