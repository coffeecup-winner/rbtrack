class CommentsController < ApplicationController
  before_filter :signed_in_user 
  
  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      flash[:success] = 'Successfully commented.'
      redirect_to @comment.issue
    else
      @issue = @comment.issue
      render 'issues/show'
      #redirect_to @comment.issue
    end
  end
end
