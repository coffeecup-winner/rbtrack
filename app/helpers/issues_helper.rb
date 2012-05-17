module IssuesHelper
  DEFAULT_CLASS = 'label'
  BLUE_CLASS = DEFAULT_CLASS + ' label-info'
  GREEN_CLASS = DEFAULT_CLASS + ' label-success'
  ORANGE_CLASS = DEFAULT_CLASS + ' label-warning'
  RED_CLASS = DEFAULT_CLASS + ' label-important'
  
  def css_id_from(str, postfix=nil)
    id = str.gsub(' ', '-').downcase
    "#{id}-#{postfix}" unless postfix.nil?
    id
  end
  def issues_id_from(str)
    css_id_from str, 'issues'
  end
  def white_icon(str)
    str + ' icon-white'
  end
  def icon_status_class_from(status)
    white_icon case status
      when Status::ACTIVE then 'icon-question-sign'
      when Status::TO_BE_FIXED then 'icon-screenshot'
      when Status::CLOSED then 'icon-minus-sign'
      when Status::FIXED then 'icon-ok'
      when Status::DUPLICATE then 'icon-tags'
      when Status::WONT_FIX then 'icon-ban-circle'
      when Status::BY_DESIGN then 'icon-ok-sign'
      else raise ArgumentError
    end
  end
  def label_status_class_from(status)
    case status
      when Status::ACTIVE then DEFAULT_CLASS
      when Status::TO_BE_FIXED then BLUE_CLASS
      when Status::CLOSED then RED_CLASS
      when Status::FIXED then GREEN_CLASS
      when Status::DUPLICATE then BLUE_CLASS
      when Status::WONT_FIX then RED_CLASS
      when Status::BY_DESIGN then ORANGE_CLASS
      else raise ArgumentError
    end
  end
  def icon_priority_class_from(priority)
    white_icon case priority
      when Priority::LOWEST then 'icon-chevron-down'
      when Priority::LOW then 'icon-chevron-down'
      when Priority::NORMAL then 'icon-minus'
      when Priority::HIGH then 'icon-chevron-up'
      when Priority::HIGHER then 'icon-chevron-up'
      when Priority::CRITICAL then 'icon-fire'
      else raise ArgumentError
    end
  end
  def label_priority_class_from(priority)
    case priority
      when Priority::LOWEST then DEFAULT_CLASS
      when Priority::LOW then GREEN_CLASS
      when Priority::NORMAL then BLUE_CLASS
      when Priority::HIGH then ORANGE_CLASS
      when Priority::HIGHER then RED_CLASS
      when Priority::CRITICAL then RED_CLASS
      else raise ArgumentError
    end
  end
end
