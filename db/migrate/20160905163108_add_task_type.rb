class AddTaskType < ActiveRecord::Migration[5.0]

  def down
    remove_column(:tasks, :type)
  end

  def up
    add_column(:tasks, :type, :string)
    say_with_time "Update existing ones" do
      Task.all.each do |task|
        case task.gitlab_internal_id
        when /^!/
          task.update_column(:type, "merge_request")
        else
          task.update_column(:type, "issue")
        end
      end
    end
  end
end
