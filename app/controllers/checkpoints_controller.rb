class CheckpointsController < ApplicationController
  
  before_filter :login_required


  def index
    @checkpoints = Checkpoint.all
	@org_checkpoints = Set.new.to_a
	current_user.organizations.each do |o|
		@org_checkpoints += o.checkpoints
	end
  unless @org_checkpoints.empty?
	  @checkpoint_users = @org_checkpoints.to_a.last.checkpoint_users
  end
    @user_checkpoints = current_user.checkpoints
    @checkpoint_users = [] if !@checkpoint_users
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @checkpoints }
    end
  end

  def all
	@checkpoints_all = Checkpoint.all
  end
  

  def show
    @checkpoint = Checkpoint.find(params[:id])
	@checkpoint_orgs = Checkpoint.get_orgs(params[:id])
	@user_orgs = current_user.organizations
	@user_events = current_user.events
	@currentevents = Array.new
	@measurements = Array.new
	@user_events.each do |event|
	  #if event.end_date >
	  #do logic here for figuring out which events/measurements
	  event.measurements.each do |measure|
	    @measurements << measure
    end
  end
  @cpoints = Array.new
	@user_orgs.each do |org|
	  org.checkpoints.each do |cpoint|
	    @cpoints << cpoint
    end
  end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @checkpoint }
    end
  end


  def new
    @checkpoint = Checkpoint.new
	@organizations = Organization.active
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @checkpoint }
    end
  end


  def edit
    @checkpoint = Checkpoint.find(params[:id])
    if @checkpoint.distributed
      flash[:error] = "We're sorry, but this checkpoint has already been distributed to participants. You cannot edit it."
      redirect_to checkpoint_path(params[:id])
    end
    @checkpoint_orgs = Checkpoint.get_orgs(params[:id])	
  end


  def create
    puts "\n[CREATE CHECKPOINT]==============================================="    
    
    # get parameters from the form
    @checkpoint = Checkpoint.new(params[:checkpoint])       # checkpoint info (name, due date)
    @org_names = params[:selected_organizations_string]     # list of organization names for dist (comma delimited string compiled by jQuery autocomplete function)
    @checkpt_orgs =  @org_names.split(/,/).map {|o| Organization.find_by_name(o)}  # turn organization names into Organization objects

    puts "NAME: #{@checkpoint.name}"

    # Validate the checkpoint as early as possible & save it so dependent objects can be built.
    @checkpoint.distributed = false
    checkpoint_save = @checkpoint.save

    # Save checkpoint_organization records for each organization the checkpoint targets
    if checkpoint_save
      @checkpt_orgs.each do |org|
        if (org == nil) then puts "ERROR: invalid org ID..."; next end    # ignore bad organization records
        @cp_org_obj = CheckpointOrganization.new({
          "checkpoint_id" => @checkpoint.id,
          "organization_id" => org.id,
        })
        @cp_org_obj.save! 
        puts "==> saved checkpoint_organization for #{org.name}"
      end
    end

    # fill in the user about what happened
    respond_to do |format|
      if checkpoint_save
        format.html { redirect_to(@checkpoint, :notice => 'Checkpoint was successfully created.') }
        format.xml  { render :xml => @checkpoint, :status => :created, :location => @checkpoint }
      else
        @organizations = Organization.active # this prevents an NPE if the submission doesn't pass validation
        format.html { render :action => "new" }
        format.xml  { render :xml => @checkpoint.errors, :status => :unprocessable_entity }
      end
    end   
    puts "[END CREATE CHECKPOINT]==========================================="
  end


  def update
    @checkpoint = Checkpoint.find(params[:id])

	# get new organizations for checkpoint to update from form
	@organization_names = params[:selected_organizations_string]
	@organization_arr = @organization_names.split(/,/)
	
	# query existing data in checkpoint_organizations db table
	@existing_orgs = CheckpointOrganization.get_existing_orgs(params[:id])
	if(CheckpointOrganization.get_existing_orgs(params[:id]).count != 0)
		# delete all checkpoint_organizations data that are no longer applicable
		@data_count = 0
		while(@existing_orgs[@data_count] != nil)
			@o_name = @existing_orgs[@data_count]['name']
			@data_id = @existing_orgs[@data_count]['id']
			@found = 0 # if this existing organization is unchanged
			@organization_arr.each do |o|
				if(o == @o_name)
					# this existing checkpoint_organizations data record is still applicable, skip to next
					# delete this organization name from @organization_arr (since no need to update)
					@organization_arr.delete_if {|x| x == o }
					@found = 1
				end
			end
			if(@found == 0)
				# this existing checkpoint_organizations data record is no longer applicable,
				# delete this organization from checkpoint_organizations db table 
				@to_delete = CheckpointOrganization.find(@data_id)
				@to_delete.destroy				
			end
			@data_count += 1
		end
	end
	
	# update db with any new organizations for this checkpoint
	if(@organization_arr.length > 0)
		@organization_arr.each do |o|
			@checkpoint_organization = CheckpointOrganization.new
			@checkpoint_organization.checkpoint_id = @checkpoint.id
			@query_result = Organization.get_id(o)
			@checkpoint_organization.organization_id = @query_result[0]['id']
			@checkpoint_organization.save
		end
	end	
	
    respond_to do |format|
      if @checkpoint.update_attributes(params[:checkpoint])
        format.html { redirect_to(@checkpoint, :notice => 'Checkpoint was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @checkpoint.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @checkpoint = Checkpoint.find(params[:id])
	
	# if checkpoint has been distributed, it cannot be deleted
    if @checkpoint.distributed
      flash[:error] = "We're sorry, but this checkpoint has already been distributed to participants. You cannot delete it."
      redirect_to checkpoint_path(params[:id])
	  return
    end	
	
	@checkpoint_organizations = CheckpointOrganization.get_existing_orgs(params[:id])
	
	@data_count = 0
	if(CheckpointOrganization.get_existing_orgs(params[:id]).count != 0)
		while(@checkpoint_organizations[@data_count] != nil)
			@data_id = @checkpoint_organizations[@data_count]['id']
			@to_delete = CheckpointOrganization.find(@data_id)
			@to_delete.destroy
			@data_count += 1
		end
	end
	
	@checkpoint.destroy
	
    respond_to do |format|
      format.html { redirect_to(checkpoints_url) }
      format.xml  { head :ok }
    end
  end
  
  # Displays JSON object of all organization names
  def organizations
	@organizations = Organization.all
	@organization_names = []
	@organizations.each do |o|
		@organization_names << o.name
	end
	
	respond_to do |format|
		format.html { render :json => @organization_names }
	end
  end
  
  # Distributes a checkpoint that has already been created to its target organizations.
  # After this function has been called, the checkpoint is final and cannot be modified.
  def distribute

    puts "\n[DISTRIBUTE CHECKPOINT]==============================================="
    successful_checkpoints = 0;   

    # Get the checkpoint and it's checkpoint_organizations
    @checkpoint = Checkpoint.find(params[:id])                # the checkpoint
    @organizations = @checkpoint.organizations                # target organizations

    # Verify that this checkpoint isn't yet distributed
    if (@checkpoint.distributed)
      flash[:error] = "This checkpoint has already been distributed. It can't be distributed again."    
      redirect_to :back
    end

    # compute the subset of participants who need to receive this checkpoint.
    # only consider participants in the organizations specified by the checkpoint.
    # use a set to avoid duplication of students who belong to multiple organizations.
    @student_set = Set.new
    puts "\nComputing participant set..."
    @organizations.each do |org|
      if (org == nil) then puts "ERROR: invalid org ID..."; next end    # ignore bad organization ID's
      puts "==> adding participants for: #{org.name}"
      @users = org.users.reject{ |u| (!u.is_participant?) }             # non-participants don't get checkpoints
      @student_set.merge(@users)                                        # add users not already in the set
    end

    # iterate through student set and determine which students actually need to get checkpoints.
    # a student needs a checkpoint if they've been to a new event since their last checkpoint.
    # make a checkpoint_user for students who are eligible for a new checkpoint.
    puts "\nProcessing student set..."
    @student_set.each do |stu|

      # check eligibility of the student
      print "==> #{stu.full_name} "
      @stu_checkpt_events = stu.events_since_last_checkpoint
      if (@stu_checkpt_events.empty?) then puts "[INELIGIBLE]"; next end         # skip students with no "new" events
      print "[ELIGIBLE]"   

      # save a checkpoint_user record   
      @cp_usr_obj = CheckpointUser.new({                                         # save a checkpoint_user record
        "checkpoint_id" => @checkpoint.id,
        "user_id" => stu.id,
      })
      @cp_usr_obj.save!
      
      # determine set of relevant measurements for this checkpoint
      # use a set to avoid duplication of the measurements.
      @measurement_set = Set.new
      @stu_checkpt_events.map{|ce| @measurement_set.merge(ce.measurements)}

      # determine the entire set of questions relevant to these measurements
      # sort the questions randomly and choose at most Checkpoint.MAX_CHECKPOINT_QUESTIONS to give.
      @questions = @measurement_set.to_a.map{|meas| meas.questions}.flatten.sort_by{rand}.first(Checkpoint::MAX_CHECKPOINT_QUESTIONS)
      questions_assigned = @questions.size

      # create empty responses for each question assigned to this participant.
      @questions.each do |question|
        @newresp = Response.new({
          "checkpoint_user_id" => @cp_usr_obj.id,
          "user_id" => stu.id,
          "question_id" => question.id,
          "response_value" => Response::EMPTY_RESPONSE_VALUE
        })
        @newresp.save!
        puts "assigned question: #{@newresp.question.content}"
      end
      
      # destroy the checkpoint_user if no questions could be assigned to the student.
      # when this happens, the student doesn't need to complete anything.
      if (questions_assigned == 0)
        @cp_usr_obj.destroy
      else
        successful_checkpoints += 1
      end
      puts " - received #{questions_assigned} questions"
    end

    # notify the user of what happened
    if (successful_checkpoints > 0)
      @checkpoint.distributed = true
      flash[:notice] = "Thank you! Your checkpoint has been distributed to the participants."
      puts "\nSuccessful Distribution!"
    else
      @checkpoint.distributed = false
      flash[:warning] = "We're sorry, but we didn't have enough information to build checkpoints for these students. <br />" +
                        "Please try again when the students have attended more events."
      puts "\nUnable to Assign! Insufficient students, measurements, events, or questions"
    end

    # save the checkpoint to finalize it, and redirect back to the show page
    @checkpoint.save!
    redirect_to :action => 'show', :id => @checkpoint.id
    puts "\n[CHECKPOINT DISTRIBUTED]=============================================="    
  end

  # HACK HACK HACK
  # this links together events, users, measurements, and questions from the test data
  # TODO: this is not meant to be a public-facing function. remove this before pushing to heroku.
  def link_test_data

    if (current_user.username != "rbuckheit" || Rails.env != "development")
      flash[:error] = "Sorry, you don't have access to this function."
      redirect_to checkpoints_path
    end

    # link users to events
    users = User.all.reject{|u| !u.is_participant?}
    events = Event.all
    users.each do |usr|
      eventz = events.sort_by{rand}.first(5)
      eventz.each do |ev|
        Registration.new({
          "user_id" => usr.id,
          "event_id" => ev.id,
        }).save!
      end
    end

    # link users to organizations
    organizations = Organization.all.active
    users.each do |usr|
      organizationz = organizations.sort_by{rand}.first(3)
      organizationz.each do |org|
        OrganizationUser.new({
          "user_id" => usr.id,
          "organization_id" => org.id
        }).save!
      end
    end

    # link events to measurements
    measurements = Measurement.all    
    events.each do |ev|
      measurementz = measurements.sort_by{rand}.first(5)
      measurementz.each do |mz|
        EventMeasurement.new({
          "event_id" => ev.id,
          "measurement_id" => mz.id
        }).save!
      end
    end

    # make questions randomly and link them to measurements
    if (Question.all.size <= 50)
      (0..50).each do |ques_num|
        Question.new({
          "content" => "Random_gen_question_#{ques_num}",
          "measurement_id" => Measurement.all.sort_by{rand}.first.id,
          "active" => true,
          "question_type" => 1
        }).save!
      end
    end

    flash[:notice] = "Linked database objects for testing checkpoints."
    redirect_to checkpoints_path
  end
  
  # allows a user to take a checkpoint
  def take_checkpoint
    puts "*** USER TAKING CHECKPOINT ***"
    invalid = false
    
    begin
       @checkpoint_user = CheckpointUser.find(params[:id]) 
       puts "invalid checkpoint_user - bad ID!"
    rescue ActiveRecord::RecordNotFound 
      invalid = true 
    end
    
    if (!invalid && @checkpoint_user.is_complete?) then invalid = true end
    
    if (invalid || (current_user.id != @checkpoint_user.user_id))
      puts "checkpoint ID mismatch: actual #{current_user.id} expected: #{@checkpoint_user.user_id}}!"
      flash[:error] = "You cannot access this checkpoint."
      redirect_to checkpoints_path
    else
      # these objects go to the view
      @responses = @checkpoint_user.responses.all
      puts @responses
    end
  end

  # collect a submission
  def complete_checkpoint
    
    puts "*** CHECKPOINT SUBMITTED ***"
    @responses = params[:responses]
    all_responses_complete = true
    valid_responses = false
	
    if (@responses != nil && validate_user_responses(@responses))
      valid_responses = true
	    # Note! @responses array's indexes are strings with " " such as "0" and not 0
	    # loop through and save each response's value in database
	    responses_arr = (0..@responses.length-1).map{|i| @responses[i.to_s]}
	    responses_arr.each do |resp|
	      puts "saving user response for #{resp}"
        if (!save_user_responses(resp)) then all_responses_complete = false; puts "<<USER LEFT BLANK>>" end
      end
	  end
	  
	  if (valid_responses && all_responses_complete)
	    # update checkpoint score
	    @response_id = @responses["0"]["id"]
	    @response_obj = Response.find(@response_id)
	    update_checkpoint_score(@response_obj.checkpoint_user_id)
	    
	    # ******************
	    # Adding a snapshot to the database to speed up later queries
	      create_snapshot(current_user, @responses, @response_obj.checkpoint.id)
	    
	    # ******************
	    
	    flash[:notice] = "Your checkpoint has been successfully submitted."
	    redirect_to checkpoint_results_path(@response_obj.checkpoint_user_id)
    else
      puts "Checkpoint left incomplete: valid_responses = #{valid_responses}, all_responses_complete=#{all_responses_complete}"
      # TODO: redirect them back to their specific checkpoint
      flash[:warning] = "We saved your checkpoint, but you left some questions blank. Please finish them when you get a chance!"
      redirect_to checkpoints_path
    end
  end
  
  # checks the responses in the post array to see if they are valid
  # returns true if all response id's are valid and if all responses belong to the current user
  # this prevents one user from submitting responses for another.
  def validate_user_responses(responses)
    failed = false
    puts "*** VALIDATING USER RESPONSES ***"

    @i = 0
    
    while(@i < responses.length)
      @response = nil
      @index = @i.to_s
      @resp = responses[@index]
      @id = @resp[:id]
      puts "*** VALIDATING response no. " + @i.to_s + ", ID=" + @id + " ***"    
  
      begin 
        @response = Response.find(@id) 
      rescue ActiveRecord::RecordNotFound
        puts "RESPONSE NOT FOUND"
        failed = true
        break
      end
	
		  if (@response.user.id != current_user.id)
		    puts ("ID MISMATCH: actual: #{current_user.id} expected: #{@response.user.id}")
		    failed = true
		    break 
		  end
		  @i += 1
	  end
	  
    return !failed
  end
  
  # helper to save a user's response when they take a checkpoint
  # store responses
  def save_user_responses(resp)
    @response = Response.find(resp[:id])
    @question = @response.question
    resp_val_string = Response::EMPTY_RESPONSE_VALUE
    if (@question.question_type == Question::TYPES['short_answer'])
      resp_val_string = resp[:response_value]
    elsif (@question.question_type == Question::TYPES['multiple_choice'] || @question.question_type == Question::TYPES['scale'])
      # look through the multiple choice options and see which one is selected
      # note: for now these are implemented in the same way. in the future, scale may be a slider.
      resp_val_string = resp[:response_value]
    elsif (@question.question_type == Question::TYPES['multiple_select'])
      # look through the multiple select options and see which one(s) are selected
	  @option_count = 0
	  @option_arr = []
	  while(@option_count < @response.question.question_options.length)
		puts "** OPTION " + @option_count.to_s + " ***"
		@index = @option_count.to_s
		if(resp["response_values"][@index] != "")
			@option_arr << resp["response_values"][@index]
		end
		@option_count += 1
	  end
      resp_val_string = @option_arr.join(",")
    end
    
    puts "RESPONSE VALUE STRING: #{resp_val_string}"
    
    if (resp_val_string == "")
      return false
    else
      # update the stuff here
      @response.response_value = resp_val_string
      @response.save!
      return true
    end
  end

  # TODO: currently just sets score to 1 to prevent the checkpoint from reappearing even after being completed
  # updates score of the user after checkpoint is completed
  def update_checkpoint_score(checkpoint_user_id)
	@checkpoint_user = CheckpointUser.find(checkpoint_user_id)
	@checkpoint_user.score = 1 #TODO
	@checkpoint_user.save!
  end
  
  #NOTE:
  # => input from params[:id] is a checkpoint_user ID, NOT a checkpoint ID.
  def results
    @checkpoint_user = CheckpointUser.find(params[:id])
    @user = current_user

    # redirect users trying to access other checkpoints
    if (!current_user.is_admin? && !current_user.is_orgleader? && @checkpoint_user.user.id != current_user.id)
      puts "ACCESS EXCEPTION: non-admin user #{current_user.id} is trying to access #{@checkpoint_user.user.id}'s checkpoint"
      flash[:error] = "You don't have permission to access this checkpoint's results."
      redirect_to checkpoints_path
    end
    
    # make sure checkpoint is complete
    if (!@checkpoint_user.is_complete?)
      flash[:error] = "Sorry, this checkpoint hasn't been completed yet."
      redirect_to checkpoints_path
    end
    
    # view does the rest...
    
  end
  
  # analysis of test results for an organization.
  def organization_analysis
    
    @organization = Organization.find(params[:id])
    
    # make sure user is sys admin, or orgleader of the organization that they want to look at.
    if (!current_user.is_admin? && !@organization.organization_leaders.map{|x| x.id}.include?(current_user.id))
      redirect_to organizations_path
      flash[:error] = "Sorry, you cannot access this portion of the site."
    end

    # build hash of all user scores for each measurement.
    @measurements_scores = Hash.new(Array.new)
    checkpt_users = Set.new
    responses = Set.new
    
    @organization.checkpoints.map{|ou| checkpt_users.merge(ou.checkpoint_users)}
    checkpt_users.map{|cu| responses.merge(cu.responses.reject{|resp| !resp.is_complete?})}

    responses.each do |resp|
      measureStr = resp.question.measurement.name
      @measurements_scores[measureStr] = []  if (@measurements_scores[measureStr] == nil) 
      @measurements_scores[measureStr] = @measurements_scores[measureStr] << resp.percent_score
    end
    
  end
  
  # Create a series of snapshots speed up later queries
  def create_snapshot(user, responses, checkpoint_id)
    # get the response ids out of the hash passed
    resp_ids = responses.map{|k1,v1| v1.map{|k2,v2| v2 if k2 == "id"}.compact!.join("").to_i }
    
    # get all the measurement_category_ids
    mc_ids = MeasurementCategory.all.map{|mc| mc.id}
    
    # create two new hashes we need to store info temporarily
    earned = Hash.new
    possible = Hash.new
    
    resp_ids.each do |r_id|
      # get the response
      response = Response.find(r_id)
      mc_id = response.question.measurement.measurement_category.id    
      # get points earned and add to hash
      pts_earned = response.points_earned
      if earned.has_key? mc_id
        earned[mc_id] += pts_earned
      else
        earned[mc_id] = pts_earned
      end
      # get points possible and add to hash
      pts_possible = response.points_total
      if possible.has_key? mc_id
        possible[mc_id] += pts_possible
      else
        possible[mc_id] = pts_possible
      end
    end
    
    mc_ids.each do |mc_id|
      if earned.keys.include? mc_id 
        snap = Snapshot.new
        # set the object's values
        snap.percent_score = earned[mc_id].to_f/possible[mc_id]
        snap.user_id = user.id
        snap.checkpoint_id = checkpoint_id
        snap.measurement_category_id = mc_id
        # save this snapshot
        snap.save!
      end
    end
  end

end
