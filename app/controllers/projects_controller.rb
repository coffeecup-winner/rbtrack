class ProjectsController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :index]

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
  def index
    @projects = Project.paginate(page: params[:page])
  end

private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: 'Please sign in.'
    end
  end
end
