class SearchController < ApplicationController
  def search
    @query = params[:query]
    @projects = Project.search(@query)
    @issues = Issue.search(@query)
  end
end
