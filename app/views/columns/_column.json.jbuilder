json.extract! column, :id, :name, :min, :max, :board_id, :created_at, :updated_at
json.url column_url(column, format: :json)