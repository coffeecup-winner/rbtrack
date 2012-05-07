class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end
  def create
    @project = Project.new(params[:project])
    if @project.save
      TeamMembership.create(project: @project, user: current_user, owner: true)
      flash[:success] = "Project #{@project.name} have been created."
      redirect_to @project
    else
      render :new
    end
  end
  def show
    @project = Project.find(params[:id])
  end
end
