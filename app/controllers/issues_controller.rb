class IssuesController < ApplicationController
  before_filter :signed_in_user, except: :show
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def new
    @issue = Issue.new
    @selected_project = ''
    project_id = params[:project]
    if project_id
      project = Project.find_by_id(project_id)
      if project
        @selected_project = project.name
      end
    end
  end
  def create
    issue_info = get_issue_info()
    @issue = Issue.new(issue_info)
    @issue.user = current_user
    if @issue.save
      redirect_to @issue
    else
      render :new
    end
  end
  def show
    @issue = Issue.find(params[:id])
  end
  def edit
    @issue = Issue.find(params[:id])
  end
  def update
    @issue = Issue.find(params[:id])
    if params[:close]
      set_issue_status(Status::CLOSED)
      redirect_to @issue
    elsif params[:reopen]
      set_issue_status(Status::ACTIVE, close = false)
      redirect_to @issue
    elsif params[:fixed]
      set_issue_status(Status::FIXED)
      redirect_to @issue
    elsif params[:by_design]
      set_issue_status(Status::BY_DESIGN)
      redirect_to @issue
    elsif params[:wont_fix]
      set_issue_status(Status::WONT_FIX)
      redirect_to @issue
    else
      if @issue.update_attributes(params[:issue])
        flash[:success] = 'Issue was successfully updated.'
        redirect_to @issue
      else
        render :edit
      end
    end
  end
  def destroy
    issue = Issue.find(params[:id])
    issue.destroy
    flash[:success] = "Issue ##{issue.id}: #{issue.subject} have been removed."
    redirect_to issue.project
  end

private
  def set_issue_status(status, close = true)
    @issue.status = status
    @issue.save!
    flash[:success] = "Issue was #{close ? 'closed' : 'reopened'}."
  end

  def get_issue_info
    issue_info = params[:issue]
    project = Project.find_by_name(issue_info[:project])
    issue_info[:project_id] = project.nil? ? -1 : project.id
    issue_info.delete(:project)
    issue_info
  end
  def correct_user
    @issue = Issue.find(params[:id])
    if params[:close]
      redirect_to(root_path) unless current_user?(@issue.user) || current_user.admin?
    end
    if params[:fixed] || params[:by_design] || params[:wont_fix]
      redirect_to(root_path) unless @issue.project.users.include?(current_user)
    end
    redirect_to(root_path) unless current_user?(@issue.user) || @issue.project.users.include?(current_user) || current_user.admin?
  end
end
