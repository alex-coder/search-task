module ApplicationHelper
  def sitename
    "SputnikTask"
  end

  def preview_text(text, length = 200)
    "#{text[0...length]}..."
  end
end
