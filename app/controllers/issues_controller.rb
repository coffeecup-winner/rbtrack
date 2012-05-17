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
      set_issue_status(Status::ACTIVE, action = 'reopened')
      redirect_to @issue
    elsif params[:confirm]
      set_issue_status(Status::TO_BE_FIXED, action = 'confirmed')
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
    elsif params[:set_priority]
      set_issue_priority params[:set_priority]
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
  def set_issue_status(status, action = 'closed')
    @issue.status = status
    @issue.save!
    flash[:success] = "Issue was #{action}."
  end
  def set_issue_priority(priority_str)
    priority = priority_str.to_i
    @issue.priority = priority
    @issue.save!
    flash[:success] = 'Issue priority was updated.'
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
      redirect_to(root_path) unless current_user?(@issue.user)
    end
    if params[:set_priority]
      redirect_to(root_path) unless @issue.project.users.include?(current_user)
    end
    if params[:confirm] || params[:fixed] || params[:by_design] || params[:wont_fix]
      redirect_to(root_path) unless @issue.project.users.include?(current_user)
    end
    redirect_to(root_path) unless current_user?(@issue.user) || @issue.project.users.include?(current_user) || current_user.admin?
  end
end
