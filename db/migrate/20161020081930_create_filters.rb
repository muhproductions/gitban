class CreateFilters < ActiveRecord::Migration[5.0]
  def change
    create_table :filters do |t|
      t.string :type
      t.string :match
      t.references :column, foreign_key: true

      t.timestamps
    end
  end
end
