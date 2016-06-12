# coding: UTF-8
class BulkMailsController < ApplicationController

  before_filter :admin_required

  def newbulkmail
  end

  def sendbulkmail
    case params[:recievers]
    when "1"
      # ALLA
      users = User.all
    when "2"
      # INTE GRUNDTIPPAT
      users = User.joins('LEFT JOIN winners_tips ON winners_tips.user_id = users.id').where("winners_tips.user_id IS NULL")
    when "3"
      # INTE TIPPAT NÄSTA MATCH
    when "4"
      # INTE LÄMNAT VIN
      users = User.where(:wine => false)
    end

    users.each do |u|
      begin 
        UserMailer.bulk(u.email, params[:subject], params[:body]).deliver
      rescue Exception => e
        # do nothing, just loop back and try the next email.
      end
    end
    redirect_to :root
  end

  def reminder_winnerstip
    users = User.joins('LEFT JOIN winners_tips ON winners_tips.user_id = users.id').where("winners_tips.user_id IS NULL")
    users.each do |u|
      begin
        UserMailer.reminder_winnerstip(u).deliver
      rescue Exception => e
        # do nothing, just loop back and try the next email.
      end
    end
    redirect_to :root
  end

  def reminder_wine
    users = User.where(:wine => false)
    users.each do |u|
      begin
        UserMailer.reminder_wine(u).deliver
      rescue Exception => e
        # do nothing, just loop back and try the next email.
      end
    end
    redirect_to :root
  end

end
