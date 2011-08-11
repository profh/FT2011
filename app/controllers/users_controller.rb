class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @user = User.new
    # adding to the new method...
    if (current_user.is_admin?)
      @organizations = Organization.all
    elsif (current_user.is_organization_admin?)
      @organizations = current_user.organizations # they can be added to the organizations of their admin
    end
  end

  def create
    @user = User.new(params[:user])
    @user.active = true
    if(@user.level == User::USER_LEVELS["system_admin"])
      puts "a   -"
      if(@user.save(false))
        flash[:notice] = "Admin created."
        UserMailer.deliver_registration_confirmation(@user, @password_string)
        org_save = true
        usr_save = true
        admin = true
      else
        flash[:error] = "Admin could not be created."
      end
    end
    
    # save the user to give it an ID.
    # otherwise, we can't create the organization_users without saving nils.
    usr_save = @user.save(false)
    
    puts "***** CREATING USER ****** "

    # build organization_users
    # create one for each organization specified in the form.
    # create another for enrollment in the "at large" organization.
    org_save = false if !admin     # indicates whether or not all organization_users saved.
    org_users = []        # array to track all organization_users that are created.
    unless (current_user.is_admin? || current_user.is_organization_admin?)
      org_ids = current_user.organization.id
      org_save = true
    else
      org_ids = params[:organization_ids]
    end

    if (org_ids != nil && usr_save && !org_save) 
      
      # save user as a member of form-specified organization(s)
      org_ids.each do |oid|          
        @organization_user = OrganizationUser.new
        @organization_user.user_id = @user.id
        if(@user.level == User::USER_LEVELS["organization_admin"])
          @organization_user.head = true
        else
          @organization_user.head = false
        end
        @organization_user.organization_id = oid
        @organization_user.save!
        org_users << @organization_user
        puts "[ORG_USER] user_id:" + @organization_user.user_id.to_s + " org_id: " + @organization_user.organization_id.to_s
      end
      
      
      org_save = true
    end

    puts "****** END CREATING USER ******  "
    
    # TODO: validate that they are being added to a correct organization...
    if usr_save && org_save
      flash[:notice] = "Thank you! The user account has been successfully created, and the user will be notified by e-mail."
      UserMailer.deliver_registration_confirmation(@user, @password_string)
      redirect_to organizations_path
    else
      # destroy these if either one fails to save
      org_users.map {|ou| ou.destroy} if usr_save
      @user.destroy if usr_save
      
      # prevent NPE if validation fails
      if (current_user.is_admin?)
        @organizations = Organization.all
      elsif (current_user.is_organization_admin?)
        @organizations = current_user.organizations # they can be added to the organizations of their admin
      end
      
      if (!org_save)
        flash[:error] = "Please specify the organization(s) this user is a part of."
      end
      #render :action => 'new'
      redirect_to(new_user_path)
    end
  end

  def edit
    unless current_user.is_participant?
		  @user = User.find(params[:id])
	  else
		  @user = current_user
	  end
  end

  def update
    unless current_user.is_participant?
		  @user = User.find(params[:id])
	  else
		  @user = current_user
	  end
	
	  # check birthday format
	  @birthday = params[:birthday]
	
    @user.active = true
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(organizations_url, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # -------------
  # added methods

  def all
  	if current_user.is_admin?
  		@participants_all = User.participants
  	elsif current_user.is_organization_admin?
  		@participants_all = Set.new.to_a
  		current_user.organizations.each {|o| @participants_all += o.users}
  	end
	
  	@admins_all = User.admins
  	@orgleaders_all = User.orgleaders
	
	  respond_to do |format|
      format.html # all.html.erb
    end
  end
  
  def new_admin
    @user = User.new
    @user.level = User:: USER_LEVELS["system_admin"]
  end
  
  def reseter
    if(params[:format] == "com" || params[:format] == "net" || params[:format] == "edu" || params[:format] == "org")
      @user = User.find_by_email(params[:id] + "." + params[:format])
    else
      @user = User.find_by_email(params[:email])
    end
    if(@user==nil)
      puts "failed password reset--=-==-=----"
      redirect_to(password_reset_path, :notice => "Your password could not be reset.")
    elsif
      puts "------====----==---"
      puts @user
      @password_string = User.generate_random_password
      @user.password = @password_string
      @user.password_confirmation = @password_string
      if(@user.save(false))
        flash[:notice] = "Thank you! Your password has been reset, and your new one will be sent by e-mail."
        UserMailer.deliver_registration_confirmation(@user, @password_string)
        @user = nil
        @user_session = UserSession.find
        @user_session.destroy
        redirect_to root_url
      else
        flash[:error] = "Your password could not be reset."
        @user = nil
        @user_session = UserSession.find
        @user_session.destroy
        redirect_to root_url
      end
    end
  end
  
  def reset
  end
  
end
