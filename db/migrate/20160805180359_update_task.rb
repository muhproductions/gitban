class UpdateTask < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :gitlabid
    add_column :tasks, :gitlab_id, :integer
    add_column :tasks, :gitlab_internal_id, :integer
  end
end
