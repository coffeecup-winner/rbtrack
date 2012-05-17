module IssuesHelper
  def css_id_from(str, postfix=nil)
    id = str.gsub(' ', '-').downcase
    "#{id}-#{postfix}" unless postfix.nil?
    id
  end
  def issues_id_from(str)
    css_id_from str, 'issues'
  end
end
