# coding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "support@em2016.ifkff.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  
  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "em2016.ifkff.org - Välkommen!"
  end

  def email_verification(user)
    @user = user
    mail :to => user.email, :subject => "em2016.ifkff.org - Verifiera din mail-adress"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "em2016.ifkff.org - Nytt lösenord"
  end

  def user_cleared(user)
    @user = user
    mail :to => user.email, :subject => "em2016.ifkff.org - Godkänd för att tippa"
  end

  def bulk(users, subject, message)
    @message = message
    mail :to => users, :subject => subject
  end
  
end
