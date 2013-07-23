class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.datetime :date
      t.string :crit
      t.string :message

      t.timestamps
    end
  end
end
