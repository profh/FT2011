class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery
  
  def require_admin
    if !(current_user && current_user.is_admin?)
      session[:return_to] = request.request_uri #save the page that person was nevigating to before login was required
      redirect_to :controller => "login" #, :action => "login"
      flash[:warning] = "You need to be an administrator to access this functionality. Please log in."
    end
  end
  
  def require_org_leader
    if !(current_user && current_user.is_organization_admin?)
      session[:return_to] = request.request_uri
      redirect_to :controller => "login" #, :action => "login"
      flash[:warning] = "You need to be an organization leader to access this functionality. Please log in."
    end    
  end
  
  def require_admin_or_orgleader
    if !(current_user && (current_user.is_organization_admin? || current_user.is_admin?))
      session[:return_to] = request.request_uri
      redirect_to :controller => "login" #, :action => "login"
      flash[:warning] = "You need to be an organization leader or an administrator to access this functionality. Please log in."
    end    
  end
  
  #   def require_login
  # if !(current_user)
  #     session[:return_to] = request.request_uri
  #  redirect_to :controller => "login" #, :action => "login"
  #       flash[:warning] = "You need to be a member to access this functionality. Please log in."
  #     end 
  #   end
end
