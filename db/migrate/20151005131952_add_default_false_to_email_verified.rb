class AddDefaultFalseToEmailVerified < ActiveRecord::Migration
  def change
    change_column :users, :email_verified, :boolean, :default => false
  end
end
