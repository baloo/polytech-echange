class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    @preview_mode = false
    @comment = Comment.new
    @comment.parent_id = params[:parent_id]
    @comment.announcement_id = params[:announcement_id]

    # Controle de l'ACL
    raise Exceptions::UserCreateDeniedError.new unless @comment && @comment.creatable_by?(current_user)

    respond_to do |format|
      format.html #new.html.haml
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @comment = Comment.new(params[:comment])

    # Controle de l'ACL
    raise Exceptions::UserCreateDeniedError.new unless @comment && @comment.creatable_by?(current_user)

    @preview_mode = (params[:commit] == t(:comment_preview, :default => 'preview'))
    @comment.parent_id = params[:comment][:parent_id]
    @comment.user = current_user

    respond_to do |format|
      if !@preview_mode && @comment.save
        flash[:notice] = t :comment_successfully_created
        format.html { redirect_to(@comment.announcement) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
end
