class SettingsController < ApplicationController

  def index
    @user = current_user
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
