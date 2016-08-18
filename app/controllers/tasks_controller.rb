class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  after_action :resort, only: [:update]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    @boards = Board.all
    @tasks_unassigned = Task.where(column: [nil, 0])

    @grouped_options = Board.all.map{|b| [b.name, b.columns.map{|c| [c.name, c.id]}]}
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
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
          format.html { redirect_back fallback_location: :tasks }
          format.json { render :show, status: :ok, location: @task }
        else
          source = Column.find(@task.column_id_previous_change.first)
          ActionCable.server.broadcast(
            'notifications',
            dom_id: "##{@task.id}",
            name: @task.title,
            source: source.name,
            destination: @task.column.name
          )
          format.json { render json: @task }
        end
      else
        unless request.xhr?
          format.html { render :edit }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:milestone_id, :assignee_id, :title, :link, :gitlab_id, :project_id, :state, :labels, :due_date, :position, :comments_id, :column_id)
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
