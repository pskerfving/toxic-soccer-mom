class User < ActiveRecord::Base
  has_many :tips
  has_one :winners_tip

  belongs_to :approved_by, :class_name => "User", :foreign_key => "approved_by_id"
  belongs_to :wine_by, :class_name => "User", :foreign_key => "wine_by_id"

  has_many :authorizations

  validates :name, :email, :presence => true

  def send_user_cleared
    if self.cleared?
      UserMailer.user_cleared(self).deliver
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
