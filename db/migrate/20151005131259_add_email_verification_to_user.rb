class AddEmailVerificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :email_verified, :boolean

    add_column :users, :email_verification_token, :string

    add_column :users, :email_verification_sent_at, :datetime

  end
end
