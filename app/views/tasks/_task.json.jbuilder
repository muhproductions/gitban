json.extract! task, :id, :milestone_id, :assignee_id, :title, :link, :gitlab_id, :project_id, :state, :labels, :due_date, :position, :comments_id, :column_id, :created_at, :updated_at
json.url task_url(task, format: :json)
