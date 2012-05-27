class TeamMembershipsController < ApplicationController
  before_filter :team_member, only: :invite
  before_filter :correct_user, only: [ :accept_invitation, :reject_invitation ]

  def invite
    email = params[:user_email]
    user = User.find_by_email(email)
    if user
      if @project.users.include? user
        flash[:error] = "User with email #{email} is already a member of project #{@project.name}"
        redirect_to @project and return
      end
      if TeamMembership.find_all_by_project_id(params[:project_id]).any? { |tm| tm.user == user }
        flash[:error] = "User with email #{email} has already been invited to project #{@project.name}"
        redirect_to @project and return
      end
      invitation = TeamMembership.new(project: @project, user: user)
      invitation.invited_by = current_user
      invitation.invitation_accepted = false
      invitation.save!
      flash[:success] = "Invited #{user.name} to #{@project.name}"
    else
      flash[:error] = 'Cannot find a user with email ' + email
    end
    redirect_to @project
  end
  def accept_invitation
    @team_membership.update_attribute(:invitation_accepted, true)
    flash[:success] = "Joined project #{@team_membership.project.name}"
    redirect_to @team_membership.user
  end
  def reject_invitation
    @team_membership.destroy
    #TODO inform inviter
    flash[:alert] = "Rejected to join #{@team_membership.project.name}"
    redirect_to @team_membership.user
  end

private
  def team_member
    @project = Project.find_by_id(params[:project_id])
    redirect_to root_path unless @project && (@project.users.include? current_user)
  end
  def correct_user
    @team_membership = TeamMembership.find(params[:id])
    redirect_to root_path unless current_user? @team_membership.user
  end
end
