## Le controleur des annonces
class AnnouncementsController < ApplicationController
  ## La méthode pour afficher un index
  def index
    # On demande 10 annonces par page
    # et que les annonces aient été crées il y a moins de 10 jours
    @announcements = Announcement.find(:all, :conditions=>["created_at > ?", 10.day.ago]).paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end

  ## La méthode pour afficher une annonce
  def show
    #On demande l'annonce dont on fournit l'id
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  ## La méthode pour afficher le formulaire d'ajout
  def new
    # Par defaut on est pas en preview
    @preview_mode = false
    # On cree un nouvel objet annonce vide
    @announcement = Announcement.new

    ## Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas créable par l'utilisateur courant
    raise Exceptions::UserCreateDeniedError.new unless @announcement && @announcement.creatable_by?(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @announcement }
    end
  end

  ## La méthode pour afficher le formulaire d'édition
  def edit
    # Par defaut on est pas en preview
    @preview_mode = false
    # On crée un objet depuis l'id demandé
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas éditable par l'utilisateur courant
    raise Exceptions::UserEditDeniedError.new unless @announcement && @announcement.editable_by?(current_user)
  end

  ## La méthode pour créer l'annonce
  def create
    # On crée l'objet depuis les informations renvoyées par l'utilisateur
    @announcement = Announcement.new(params[:announcement])

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas créable par l'utilisateur courant
    raise Exceptions::UserCreateDeniedError.new unless @announcement && @announcement.creatable_by?(current_user)

    # L'utilisateur a t'il utiliser le bouton preview ?
    @preview_mode = (params[:commit] == t(:announcement_preview, :default => 'preview'))
    # L'utilisateur qui a crée l'objet est l'utilisateur courant
    @announcement.user = current_user

    respond_to do |format|
      # Si on est pas en mode preview et que l'enregistrement de l'objet dans la base se passe bien
      if !@preview_mode && @announcement.save
        # alors on redirige vers la page de l'enregistrement
        flash[:notice] = t :announcement_successfully_created
        format.html { redirect_to(@announcement) }
        format.xml  { render :xml => @announcement, :status => :created, :location => @announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  ##La méthode pour mettre à jour l'annonce
  def update
    # On crée l'objet depuis l'id demandé
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas éditable par l'utilisateur courant
    raise Exceptions::UserEditDeniedError.new unless @announcement && @announcement.editable_by?(current_user)

    # L'utilisateur a t'il utiliser le bouton preview ?
    @preview_mode = (params[:commit] == t(:announcement_preview, :default => 'preview'))

    respond_to do |format|
      # Si on est pas en mode preview et que la mise à jour des informations de l'objet dans la base se passe bien
      if !@preview_mode && @announcement.update_attributes(params[:announcement])
        flash[:notice] = t :announcement_successfully_updated
        format.html { redirect_to(@announcement) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  ##La méthode pour supprimer l'annonce
  def destroy
    # On recupere les informations de l'objet 
    @announcement = Announcement.find(params[:id])

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas supprimable par l'utilisateur courant
    raise Exceptions::UserDeleteDeniedError.new unless @announcement && @announcement.deletable_by?(current_user)

    # On le supprime et on l'enleve de la base de donnée
    @announcement.destroy

    respond_to do |format|
      # On redirige sur l'index par defaut
      format.html { redirect_to(announcements_url) }
      format.xml  { head :ok }
    end
  end
  
  ## La méthode pour afficher ses annonces
  def mine
    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas supprimable par l'utilisateur courant
    raise Exceptions::UserAccessDeniedError.new unless current_user

    # On recupere les annonces postées par l'utilisateur courant et on les paginate (affichage des numero de page)
    @announcements = Announcement.find(:all, :conditions=>["user_id = ?", current_user.id]).paginate(:page => params[:page], :per_page => 5)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end


  ## La méthode pour rechercher des annonces
  def search
    # On recupere les infos demandées par l'utilisateur
    @query = params["query"]
    # On recherche dans la base de données, on paginate et on met ca dans un tableau d'objet
    @announcements = Announcement.search(@query).paginate(:page => params[:page], :per_page => 5)
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @announcements }
    end
  end

  ## La méthode pour afficher les archives
  def archive
    # On demande les annonces de plus de 10 jours
    # On demande 5 annonces par page
    @announcements = Announcement.find(:all, :conditions=>["created_at < ?", 10.day.ago]).paginate(:page => params[:page], :per_page => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end
end
