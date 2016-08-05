module ApplicationHelper
  def cp(path)
    'active' if current_page?(path)
  end
end
