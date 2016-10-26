class AssigneesController < ApplicationController
  before_action :set_assignee, only: [:show, :edit, :update, :destroy]

  def index
    @assignees = Assignee.all
  end

  def show
  end

  def new
    @assignee = Assignee.new
  end

  def edit
  end

  def create
    @assignee = Assignee.new(assignee_params)

    if @assignee.save
      redirect_to @assignee, notice: 'Assignee was successfully created.'
    else
      render :new
    end
  end

  def update
    if @assignee.update(assignee_params)
      redirect_to @assignee, notice: 'Assignee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @assignee.destroy
    redirect_to assignees_url, notice: 'Assignee was successfully destroyed.'
  end

  private
    def set_assignee
      @assignee = Assignee.find(params[:id])
    end

    def assignee_params
      params.require(:assignee).permit(:name, :username)
    end
end
