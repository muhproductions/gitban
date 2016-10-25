class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session

  before_action :authenticate_user!
  before_action do
    @boards = Board.all
    @current_user = current_user
  end
end
