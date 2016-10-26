class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  after_action :resort, only: [:update]

  def index
    @tasks = Task.all
    @boards = Board.all
    @tasks_unassigned = Task.where(column: nil)
    @tasks_closed = Task.where(column: 0)

    @grouped_options = Board.all.map{|b| [b.name, b.columns.map{|c| [c.name, c.id]}]}
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      task_data = task_params
      if task_data[:column_id] && task_data[:column_id].empty?
        task_data[:column_id] = nil
      elsif task_data[:column_id]
        task_data[:column_id] = task_data[:column_id].to_i
      end
      if @task.update(task_data)
        unless request.xhr?
          redirect_back fallback_location: :tasks
        else
          begin
            source = if @task.column_id_previous_change
                       Column.find(@task.column_id_previous_change.first)
                     elsif @task.column
                       @task.column.id
                     else
                       nil
                     end
            ActionCable.server.broadcast(
              'notifications',
              dom_id: "##{@task.id}",
              name: @task.title,
              source: source.name,
              destination: @task.column.name,
              user: current_user.name
            )
          rescue
          end
          format.json { render json: @task }
        end
        gitlab = Gitlab.new(api_url: ENV['API_URL'], token: current_user.token)
        gitlab.update_gitlab_issue(@task)
      else
        unless request.xhr?
          render :edit
        end
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:milestone_id, :assignee_id, :title, :link, :gitlab_id, :project_id, :state, :labels, :due_date, :position, :comments_id, :column_id, :is_acknowledged)
    end

    def resort
      return unless params[:positions]
      Task.transaction do
        params[:positions].each do |col, el|
          el.each_with_index do |e, i|
            Task.find(e).update position: i
          end
        end
      end
      ActionCable.server.broadcast('boards', task: @task)
    end
end
