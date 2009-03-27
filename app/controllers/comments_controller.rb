## Le controleur des commentaires
class CommentsController < ApplicationController
  ## La méthode pour afficher un index
  def index
    # En fait on veut pas que les utilisateurs y accendent
    raise Exceptions::UserAccessDeniedError.new
    @comments = Comment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  ## La méthode pour afficher un cmmentaire
  def show
    #On demande l'annonce dont on fournit l'id
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  ## La méthode pour afficher le formulaire d'ajout
  def new
    # Par defaut on est pas en preview
    @preview_mode = false
    # On cree un nouvel objet commentaire vide
    @comment = Comment.new
    # Pour l'utilisation de threads, on a besoin de savoir quel est le commentaire parent
    @comment.parent_id = params[:parent_id]
    # Pour l'utilisation de threads, on a besoin de savoir quel est l'annonce parente
    @comment.announcement_id = params[:announcement_id]

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas créable par l'utilisateur courant
    raise Exceptions::UserCreateDeniedError.new unless @comment && @comment.creatable_by?(current_user)

    respond_to do |format|
      format.html #new.html.haml
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    # On crée l'objet depuis les informations renvoyées par l'utilisateur
    @comment = Comment.new(params[:comment])

    # Controle de l'ACL
    # On leve une exception si l'objet est incorrect ou qu'il n'est pas créable par l'utilisateur courant
    raise Exceptions::UserCreateDeniedError.new unless @comment && @comment.creatable_by?(current_user)

    # L'utilisateur a t'il utiliser le bouton preview ?
    @preview_mode = (params[:commit] == t(:comment_preview, :default => 'preview'))
    # Pour l'utilisation de threads, on a besoin de savoir quel est le commentaire parent
    @comment.parent_id = params[:comment][:parent_id]
    #L'utilisateur est celui qui a crée le commentaire
    @comment.user = current_user

    respond_to do |format|
      # Si on est pas en mode preview et que l'enregistrement de l'objet dans la base se passe bien
      if !@preview_mode && @comment.save
        # alors on redirige vers la page de l'enregistrement
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
