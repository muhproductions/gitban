class AddGitlabIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :gitlab_id, :integer
  end
end
