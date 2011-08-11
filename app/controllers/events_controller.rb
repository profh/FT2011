class EventsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @events = Event.chronological.all
    @past_events = Event.past
    @upcoming_events = Event.upcoming
	
	  @new = @upcoming_events	.reject do |e|
  		reject = true
  		current_user.organizations.each do |o|
  			reject = false if e.organizations.include? o
  		end
  		reject
  	end
	
	  if current_user.is_admin?
	    @old = @past_events.reject do |e|
    		reject = true
    		current_user.organizations.each do |o|
    			reject = false if e.organizations.include? o
    		end
    		reject
    	end
  	else
  	  @old = Set.new
      @org_ids = Set.new
  		current_user.organizations.each do |org|
  			@old += org.events.past
  		end
  	end


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end


  def show
    @event = Event.find(params[:id])
    @event_measurements = Event.get_measurements(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end


  def new
    @event = Event.new
    @measurements = Measurement.all
	  if (current_user.is_admin?)
      @organizations = Organization.all
    elsif (current_user.is_organization_admin?)
      @organizations = current_user.organizations # they can be added to the organizations of their admin
    end
	
	  @measurement_names = []
	  @measurements.each do |m|
		@measurement_names << m.name
	end
	
    respond_to do |format|
      format.html # new.html.erb 
      format.xml  { render :xml => @event }
	  format.json { render :json => @measurement_names, :action => "/events/show" } 
    end
  end


  def edit
    @event = Event.find(params[:id])
    @event_measurements = Event.get_measurements(params[:id])
    @measurements = Measurement.all
    if (current_user.is_admin?)
      @organizations = Organization.all
    elsif (current_user.is_organization_admin?)
      @organizations = current_user.organizations # they can be added to the organizations of their admin
    end
    unless(current_user.is_admin?)
      check = false
      current_user.organizations.each do |org|
        if(@event.organizations.include?(org))
          check = true
        end
      end
      unless check == true
        redirect_to(events_path, :notice => 'You cannot edit that event.')
      end
    end
  end


  def create
    @event = Event.new(params[:event])
	  @organizations = Organization.all
	  @event_count = Event.all.count
	
	
    if(@event_count == 0)
      @event_id = 1
    else
      @event_id = Event.last_id[0]['id'].to_i + 1
    end
    org_save = false
  	if !params[:organization_ids]
  	  flash[:error] = "Please specify the organization(s) for this event."
  	  #render :action => 'new'
  	  redirect_to(new_event_path)
  	  #redirect_to(events_path, :notice => 'Event could not be created.')
    elsif
  		params[:organization_ids].each do |organization_id|
			eo = EventOrganization.new
			eo.event_id = @event_id
			eo.organization_id = organization_id
			eo.save
			org_save = true
		end
	 
	
	# get measurements added
  	@measurement_names = params[:selected_measurements_string]
  	@measurement_arr = @measurement_names.split(/,/)
  	@measurement_arr.each do |m|
  		@event_measurement = EventMeasurement.new
  		@event_measurement.event_id = @event_id
  		@query_result = Measurement.get_id(m)
  		@event_measurement.measurement_id = @query_result[0]['id']
  		@event_measurement.save
  	end

    respond_to do |format|
      if (@event.save && @event_measurement.save)
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
        UserMailer.deliver_leader_event(current_user, @event)
      else
	    #  @measurements = Measurement.all #re-create the state of "new" to prevent an NPE.
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  end


  def update
    @event = Event.find(params[:id])
	
  	# get new measurements for event to update from form
  	@measurement_names = params[:selected_measurements_string]
  	@measurement_arr = @measurement_names.split(/,/)
	
  	# query existing data in event_measurements db table
  	@existing_measurements = EventMeasurement.get_existing_measurements(params[:id])
  	if(EventMeasurement.get_existing_measurements(params[:id]).count != 0)
  		# delete all event_measurements data that are no longer applicable
  		@data_count = 0
  		while(@existing_measurements[@data_count] != nil)
  			@m_name = @existing_measurements[@data_count]['name']
  			@data_id = @existing_measurements[@data_count]['id']
  			@found = 0 # if this existing measurement is unchanged
  			@measurement_arr.each do |m|
  				if(m == @m_name)
  					# this existing event_measurements data record is still applicable, skip to next
  					# delete this measurement name from @measurement_arr (since no need to update)
  					@measurement_arr.delete_if {|x| x == m }
  					@found = 1
  				end
  			end
  			if(@found == 0)
  				# this existing event_measurements data record is no longer applicable,
  				# delete this measurement from event_measurements db table 
  				@to_delete = EventMeasurement.find(@data_id)
  				@to_delete.destroy				
  			end
  			@data_count += 1
  		end
  	end
	
  	# update db with any new measurements for this event
  	if(@measurement_arr.length > 0)
  		@measurement_arr.each do |m|
  			@event_measurement = EventMeasurement.new
  			@event_measurement.event_id = @event.id
  			@query_result = Measurement.get_id(m)
  			@event_measurement.measurement_id = @query_result[0]['id']
  			@event_measurement.save
  		end
  	end
	
  	# Edit the organization list
  	if !params[:organization_ids]
  	  flash[:error] = "Please specify the organization(s) for this event."
  	  #render :action => 'new'
  	  redirect_to(edit_event_path)
  	  #redirect_to(events_path, :notice => 'Event could not be created.')
    elsif
  		params[:organization_ids].each do |organization_id|
  			eo = EventOrganization.new
  			eo.event_id = @event.id
  			eo.organization_id = organization_id.to_i
  			eo.save
        # org_save = true
  		end
  	end
	
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end   
  end


  def destroy
    @event = Event.find(params[:id])
    check = @event.destroy if current_user.is_admin?
       
    # unless(current_user.is_admin?)
    #   check = false
    #   current_user.organizations.each do |org|
    #     if(@event.organizations.include?(org))
    #       check = true
    #     end
    #   end
    # end
    # if(check == true)
    #   @event.destroy
    # end

    respond_to do |format|
      if !check
        format.html { redirect_to(events_url, :notice => 'You cannot delete that event.') }
      elsif
        format.html { redirect_to(events_url) }
      end
      format.xml  { head :ok }
    end
  end  
  
  # List all events
  def all
    if(current_user.is_admin?)
	    @events_all = Event.all
    elsif
      @events_all = Set.new
      @org_ids = Set.new
			current_user.organizations.each do |org|
				@events_all += org.events
			end
    end
  end
  
  # List all past events
  def past
    if(current_user.is_admin?)
	    @past_events_all = Event.past_all
    elsif
      @past_events_all = Set.new
      @org_ids = Set.new
			current_user.organizations.each do |org|
				@past_events_all += org.events.past
			end
    end
  end  

  # Displays JSON object of all measurement names
  def measurements	
	  @measurements = Measurement.all
	  @measurement_names = []
	  @measurements.each do |m|
		  @measurement_names << m.name
	  end
	
	  respond_to do |format|
		  format.html { render :json => @measurement_names }
	  end
  end
end
