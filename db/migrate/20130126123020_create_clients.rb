class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.string :city
      t.decimal :account_balance, :precision => 16, :scale => 2
      t.decimal :advance_payment, :precision => 16, :scale => 2
      t.decimal :total_amount_of_purchases, :precision => 16, :scale => 2
      t.boolean :is_wholesale_customer
      t.integer :remote_id

      t.timestamps
    end

    add_index(:clients, :remote_id)
  end
end
