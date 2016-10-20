class FiltersController < ApplicationController
  def create
    @filter = Filter.new(filter_params)

    if @filter.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    Filter.find(params[:id]).destroy
    redirect_to :back
  end

  private

  def filter_params
    params.require(:filter).permit(:type, :match, :column_id)
  end
end
