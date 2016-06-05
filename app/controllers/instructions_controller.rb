# coding: UTF-8
class InstructionsController < ApplicationController

  def instructions
    @show_banner = !current_user
  end

end
