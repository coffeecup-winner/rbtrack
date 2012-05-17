class UpdateDefaultIssuePriorities < ActiveRecord::Migration
  def up
    Issue.all.each do |issue|
      if issue.priority.nil?
        issue.priority = Priority::NORMAL
        issue.save!
      end
    end
  end

  def down
  end
end
