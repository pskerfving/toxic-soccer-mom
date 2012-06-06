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
    when "3"
      # INTE TIPPAT NÄSTA MATCH
    when "4"
      # INTE LÄMNAT VIN
      users = User.where(:wine => false)
    end

    users.each do |u|
      UserMailer.bulk(u.email, params[:subject], params[:body]).deliver
    end
    redirect_to :root
  end

end
