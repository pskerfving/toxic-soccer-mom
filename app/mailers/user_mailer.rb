# coding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "support@euro2012.ifkff.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  
  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "euro2012.ifkff.org - Välkommen!"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "euro2012.ifkff.org - Nytt lösenord"
  end
  
  def user_cleared(user)
    @user = user
    mail :to => user.email, :subject => "euro2012.ifkff.org - Godkänd för att tippa"
  end
end
