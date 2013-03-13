class CreateSynchronizations < ActiveRecord::Migration
  def change
    create_table :synchronizations do |t|
      t.string :table_name
      t.string :version

      t.timestamps
    end
  end
end
