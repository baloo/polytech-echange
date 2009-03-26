class AnnouncementsController < ApplicationController
  # GET /announcements
  # GET /announcements.xml
  def index
    # On demande 10 annonces par page
    @announcements = Announcement.paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end

  # GET /announcements/1
  # GET /announcements/1.xml
  def show
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  # GET /announcements/new
  # GET /announcements/new.xml
  def new
    @preview_mode = false
    @announcement = Announcement.new

    # Controle de l'ACL
    raise Exceptions::UserCreateDeniedError.new unless @announcement && @announcement.creatable_by?(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  # GET /announcements/1/edit
  def edit
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    raise Exceptions::UserEditDeniedError.new unless @announcement && @announcement.editable_by?(current_user)

  end

  # POST /announcements
  # POST /announcements.xml
  def create
    @announcement = Announcement.new(params[:announcement])

    # Controle de l'ACL
    raise Exceptions::UserCreateDeniedError.new unless @announcement && @announcement.creatable_by?(current_user)

    @preview_mode = (params[:commit] == t(:announcement_preview, :default => 'preview'))
    @announcement.user = current_user

    respond_to do |format|
      if !@preview_mode && @announcement.save
        flash[:notice] = t :announcement_successfully_created
        format.html { redirect_to(@announcement) }
        format.xml  { render :xml => @announcement, :status => :created, :location => @announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /announcements/1
  # PUT /announcements/1.xml
  def update
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    raise Exceptions::UserEditDeniedError.new unless @announcement && @announcement.editable_by?(current_user)

    @preview_mode = (params[:commit] == t(:announcement_preview, :default => 'preview'))

    respond_to do |format|
      if !@preview_mode && @announcement.update_attributes(params[:announcement])
        flash[:notice] = 'Announcement was successfully updated.'
        format.html { redirect_to(@announcement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.xml
  def destroy
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    raise Exceptions::UserDeleteDeniedError.new unless @announcement && @announcement.deletable_by?(current_user)

    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to(announcements_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def mine
    @announcements = Announcement.find(:all, :conditions=>["user_id = ?", current_user.id]).paginate(:page => params[:page], :per_page => 5)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end
  
  def recent
    debugger
    @announcements = Announcement.find(:all, :order=>"created_at desc", :limit=> 5)
    
    respond_to do |format|
      format.html
    end
    
  end


end
