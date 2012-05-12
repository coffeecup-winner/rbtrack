class UpdateDefaultIssueStatuses < ActiveRecord::Migration
  def up
    Issue.all.each do |issue|
      if issue.status.nil?
        issue.status = Status::ACTIVE
        issue.save!
      end
    end
  end

  def down
  end
end
