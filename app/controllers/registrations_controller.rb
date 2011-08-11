class RegistrationsController < ApplicationController
  
  before_filter :login_required
  

  def index
    @registrations = Registration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
    end
  end


  def show
    @registration = Registration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.xml
  def new
    if params[:id].nil?
		  redirect_to(events_path, :notice => 'Registration page invalid.')
		  return
    end

		session[:event_id] = params[:id]
		@event = Event.find(session[:event_id])

		# check for repeated registration and full registration
		if (@event.registered?(current_user.id))
		  flash[:warning] = "You are already registered for this event. See you there!"
		  redirect_to events_path
		  return
		elsif (@event.registration_full?)
	    flash[:error] = "We're sorry, but all registrations for this event have been filled."
	    redirect_to events_path
	    return
	  end
        
    @registration = Registration.new
    if current_user.is_participant?
      @registration.user = current_user
    else
      @org_users = Set.new
      current_user.organizations.each {|o| @org_users += o.users.completep}
		end
	  
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @registration }
		end
  end


  def edit
    @registration = Registration.find(params[:id])
  end


  def create
    @org_users = Set.new
    current_user.organizations.each {|o| @org_users += o.users}
	
    success = true
    #over here
    if current_user.is_participant?
		  @registration = Registration.new(params[:registration])
      @registration.event_id = session[:event_id]
      @registration.user_id = current_user.id
      unless @registration.authority_id
        @registration.authority_id = 0
      end
      success = success and @registration.save!
    else
		  params[:org_user_ids].each do |user_id|
			  @registration = Registration.new(params[:registration])
			  @registration.event_id = session[:event_id]
			  @registration.user_id = user_id
			  success = success and @registration.save!
		  end
    end
	
    respond_to do |format|
      if success
        format.html { redirect_to(event_path(session[:event_id]), :notice => 'Registration was successfully created.') }
        format.xml  { render :xml => @registration, :status => :created, :location => @registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @registration = Registration.find(params[:id])

    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        format.html { redirect_to(@registration, :notice => 'Registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to(registrations_url) }
      format.xml  { head :ok }
    end
  end
end
