class User < ActiveRecord::Base
  has_many :tips
  has_one :winners_tip

  has_many :authorizations

  validates :name, :email, :presence => true
end
