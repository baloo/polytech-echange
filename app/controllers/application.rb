# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #On permet de catcher et logger les exceptions
  include ExceptionLoggable
  #On include le system d'authentification
  include AuthenticatedSystem


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e40a35ebe6d3192e1af50a5d52c1a850'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  # Avant tout, on execute la fonction seo_filter
  before_filter :seo_filter

  unless ActionController::Base.consider_all_requests_local
    #Le traitement des erreurs access forbidden
    rescue_from Exceptions::UserAccessDeniedError, Exceptions::UserCreateDeniedError, Exceptions::UserEditDeniedError, Exceptions::UserDeleteDeniedError, :with => :render_403
    #Le traitement des erreurs page not found
    rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction, :with => :render_404
    #Le traitement des erreurs serveur
    rescue_from RuntimeError, :with => :render_500
  end

private


  def render_403
    render :template => "shared/error_403", :layout => 'application', :status => :not_found
  end

  def render_404
    render :template => "shared/error_404", :layout => 'application', :status => :not_found
  end

  def render_500
    # hacky, but works, this logs the exception in ExceptionLoggable
    log_exception $!
    render :template => "shared/error_500", :layout => 'application', :status => :internal_server_error
  end

  def local_request?
    false
  end



protected

  #Fonction qui nous permet de parametrer différentes valeurs
  def seo_filter
    @title    = %w(Polytech-echange)
    @keywords = %w(Polytech Echange)
    @feeds    = {}
  end

end
