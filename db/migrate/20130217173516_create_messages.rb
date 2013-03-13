class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :campaign_id
      t.string :text
      t.references :messageble, :polymorphic => true
      t.string :status
      t.text :request
      t.text :response

      t.timestamps
    end
  end
end
