class SearchController < ApplicationController
  def search
    @query = params[:query]
    @projects = Project.search(@query)
    @issues = Issue.search(@query) + Issue.search(description: @query)
  end
end
