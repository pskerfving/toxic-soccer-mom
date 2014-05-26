class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :paymill_payment_id
      t.string :paymill_token

      t.timestamps
    end
  end
end
