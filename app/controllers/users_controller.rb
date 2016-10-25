class UsersController < ApplicationController

  def show
    @user = current_user

    @new_filter = Filter.new
    @filter_types = Filter::TYPES
    @filters = Filter.all

    @grouped_options = Board.all.map{|b| [b.name, b.columns.map{|c| [c.name, c.id]}]}
  end

  def update
    current_user.update(user_params)
    redirect_to :back
  end

  private

  def user_params
    params.require(:user).permit(:token, :show_scroll_hint)
  end

end
