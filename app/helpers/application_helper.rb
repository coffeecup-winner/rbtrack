module ApplicationHelper
  APPNAME = 'rbTrack'
  def full_title(page_title)
    page_title.empty? ? APPNAME : "#{APPNAME} | #{page_title}"
  end
end
