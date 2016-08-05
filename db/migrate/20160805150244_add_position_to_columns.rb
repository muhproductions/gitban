class AddPositionToColumns < ActiveRecord::Migration[5.0]
  def change
    add_column :columns, :position, :integer
  end
end
