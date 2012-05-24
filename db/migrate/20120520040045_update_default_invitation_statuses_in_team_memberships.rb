class UpdateDefaultInvitationStatusesInTeamMemberships < ActiveRecord::Migration
  def up
    TeamMembership.all.each do |tm|
      if tm.invitation_accepted.nil?
        tm.invitation_accepted = true
        tm.save!
      end
    end
  end

  def down
  end
end
