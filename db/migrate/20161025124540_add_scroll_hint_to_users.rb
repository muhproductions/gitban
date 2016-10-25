class AddScrollHintToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :show_scroll_hint, :boolean
  end
end
