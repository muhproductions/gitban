class ColumnsController < ApplicationController
  before_action :set_column, only: [:show, :edit, :update, :destroy]

  def index
    @columns = Column.all
  end

  def show
  end

  def new
    @column = Column.new
  end

  def edit
  end

  def create
    @column = Column.new(column_params)

    if @column.save
      redirect_to @column, notice: 'Column was successfully created.'
    else
      render :new
    end
  end

  def update
    if @column.update(column_params)
      redirect_to @column, notice: 'Column was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @column.destroy
    redirect_to columns_url, notice: 'Column was successfully destroyed.'
  end

  private
    def set_column
      @column = Column.find(params[:id])
    end

    def column_params
      params.require(:column).permit(:name, :min, :max, :board_id)
    end
end
