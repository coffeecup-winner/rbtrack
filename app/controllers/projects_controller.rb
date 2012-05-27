class ProjectsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :index]
  before_filter :correct_user, only: :destroy

  def new
    @project = Project.new
  end
  def create
    @project = Project.new(params[:project])
    if @project.save
      membership = TeamMembership.new(project: @project, user: current_user, owner: true)
      membership.invitation_accepted = true
      membership.save!
      flash[:success] = "Project #{@project.name} have been created."
      redirect_to @project
    else
      render :new
    end
  end
  def show
    @project = Project.find(params[:id])
  end
  def index
    @projects = Project.paginate(page: params[:page])
  end
  def destroy
    owner = @project.owner
    Issue.find_all_by_project_id(@project.id).each { |i| i.destroy }
    TeamMembership.find_all_by_project_id(@project.id).each { |tm| tm.destroy }
    @project.destroy
    flash[:alert] = "Project #{@project.name} was deleted."
    redirect_to owner
  end

private
  def correct_user
    @project = Project.find(params[:id])
    redirect_to root_path unless current_user? @project.owner
  end
end
