class UpdateDefaultIssueStatuses < ActiveRecord::Migration
  def up
    Issue.all.each do |issue|
      issue.status = Status::ACTIVE
    end
  end

  def down
    Issue.all.each do |issue|
      issue.status = nil
    end
  end
end
