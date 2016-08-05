class FixGitlabInternalIdType < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :gitlab_internal_id
    add_column :tasks, :gitlab_internal_id, :string
  end
end
