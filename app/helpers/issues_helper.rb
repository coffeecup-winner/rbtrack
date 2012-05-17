module IssuesHelper
  def css_id_from(str, postfix=nil)
    id = str.gsub(' ', '-').downcase
    "#{id}-#{postfix}" unless postfix.nil?
    id
  end
  def issues_id_from(str)
    css_id_from str, 'issues'
  end
  def icon_class_from(status)
    case status
      when Status::ACTIVE then 'icon-question-sign'
      when Status::TO_BE_FIXED then 'icon-screenshot'
      when Status::CLOSED then 'icon-minus-sign'
      when Status::FIXED then 'icon-ok'
      when Status::DUPLICATE then 'icon-tags'
      when Status::WONT_FIX then 'icon-ban-circle'
      when Status::BY_DESIGN then 'icon-ok-sign'
      else raise ArgumentError
    end + ' icon-white'
  end
  def label_class_from(status)
    default_class = 'label'
    blue_class = default_class + ' label-info'
    red_class = default_class + ' label-important'
    green_class = default_class + ' label-success'
    orange_class = default_class + ' label-warning'
    case status
      when Status::ACTIVE then default_class
      when Status::TO_BE_FIXED then blue_class
      when Status::CLOSED then red_class
      when Status::FIXED then green_class
      when Status::DUPLICATE then blue_class
      when Status::WONT_FIX then red_class
      when Status::BY_DESIGN then orange_class
      else raise ArgumentError
    end
  end
end
