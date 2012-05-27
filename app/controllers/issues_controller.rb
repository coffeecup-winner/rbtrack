class IssuesController < ApplicationController
  before_filter :signed_in_user, except: :show
  before_filter :correct_user, only: [:edit, :update]
  before_filter :correct_assign, only: :assign
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
    if params[:set_status]
      set_issue_status(params[:set_status])
      redirect_to @issue
    elsif params[:set_priority]
      set_issue_priority params[:set_priority]
      redirect_to @issue
    elsif @issue.update_attributes(params[:issue])
      flash[:success] = 'Issue was successfully updated.'
      redirect_to @issue
    else
      render :edit
    end
  end
  def assign
    @issue.assignee = @user
    @issue.save!
    flash[:success] = "Assigned issue ##{params[:id]} to #{@user ? @user.name : 'nobody'}"
    redirect_to @issue
  end
  def destroy
    issue = Issue.find(params[:id])
    issue.destroy
    flash[:success] = "Issue ##{issue.id}: #{issue.subject} have been removed."
    redirect_to issue.project
  end

private
  def set_issue_status(status_str)
    status = status_str.to_i
    @issue.status = status
    @issue.save!
    action = 'closed'
    action = 'reopened' if status == Status::ACTIVE
    action = 'confirmed' if status == Status::TO_BE_FIXED
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
    if params[:set_priority]
      redirect_to(root_path) unless @issue.project.users.include?(current_user)
    end
    if params[:set_status]
      status = params[:set_status].to_i
      if status == Status::CLOSED
        redirect_to(root_path) unless current_user?(@issue.user)
      elsif status != Status::ACTIVE
        redirect_to(root_path) unless @issue.project.users.include?(current_user)
      end
    end
    redirect_to(root_path) unless current_user?(@issue.user) || @issue.project.users.include?(current_user) || current_user.admin?
  end
  def correct_assign
    @issue = Issue.find(params[:id])
    @user = User.find_by_id(params[:user_id])
    redirect_to(root_path) unless @user.nil? || @issue.project.users.include?(@user)
    redirect_to(root_path) unless @issue.project.users.include?(current_user)
  end
end
