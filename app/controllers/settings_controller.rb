class SettingsController < ApplicationController

  def index
    @filters = Filter.all
    @user = current_user
    @new_filter = Filter.new
    @grouped_options = Board.all.map{|b| [b.name, b.columns.map{|c| [c.name, c.id]}]}
  end

  def update
    current_user.update(user_params)
    redirect_to :back
  end

  private

  def user_params
    params.permit(:token)
  end

end
