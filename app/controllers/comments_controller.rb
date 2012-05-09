# coding: UTF-8
class CommentsController < ApplicationController

  before_filter :find_commentable
  before_filter :login_required

  # GET /comments
  # GET /comments.json
  def index
    @comments = @commentable.comments

    # Create a new Comment object if the user writes a new comment on the index page.
    @new_comment = Comment.new
    @new_comment.user = current_user
    @new_comment.commentable = @commentable

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    @comment.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comments = @commentable.comments
    @comment = @comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Din kommentar är skapad."
      redirect_to :root
    else
      render :action => 'new'
    end
    
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to :root, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to :root }
      format.json { head :no_content }
    end
  end
  
  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = $1.classify.constantize.find(value)
      end
    end
    @commentabel = nil
  end
end
