class IssuesController < ApplicationController
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
      #flash[:success] = "#{@issue.project.name} issue: #{@issue.subject} has been created."
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
      @issue.status = 0
      @issue.save!
      flash[:success] = 'Issue was closed.'
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
  def get_issue_info
    issue_info = params[:issue]
    project = Project.find_by_name(issue_info[:project])
    issue_info[:project_id] = project.nil? ? -1 : project.id
    issue_info.delete(:project)
    issue_info
  end
end
