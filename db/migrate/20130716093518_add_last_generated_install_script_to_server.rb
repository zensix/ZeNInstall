class AddLastGeneratedInstallScriptToServer < ActiveRecord::Migration
  def change
    add_column :servers, :lastgeneratedpostinstallsctipt, :text
    add_column :servers, :lastgeneratedinstallscript, :text
    add_column :servers, :configlock, :boolean
  end
end
