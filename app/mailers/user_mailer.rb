# coding: UTF-8
class UserMailer < ActionMailer::Base
  default from: "support@ifkff.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  
  def welcome(user)
    @user = user
    mail :to => user.email, :subject => "EM 2016 - Välkommen!"
  end

  def email_verification(user)
    @user = user
    @authorization = Authorization.where(:user_id => @user.id).first
    mail :to => user.email, :subject => "EM 2016 - Bekräfta din mail-adress"
  end

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "EM 2016 - Nytt lösenord"
  end

  def user_cleared(user)
    @user = user
    mail :to => user.email, :subject => "EM 2016 - Godkänd för att tippa"
  end

  def bulk(users, subject, message)
    @message = message
    mail :to => users, :subject => subject
  end

  def reminder_winnerstip(user)
    mail :to => user.email, :subject => "EM2016 - Påminnelse grundtips"
  end
  
end
