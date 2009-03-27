# La classe de controle des utilisateurs
class UsersController < ApplicationController


  # render new.rhtml
  def new
    @user = User.new
  end

  # La gestion du formulaire d'enregistrement
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = t :user_thanks_signing_up
    else
      render :action => 'new'
    end
  end

end
