class AnnouncementsController < ApplicationController
  
  before_filter :login_required
  

  def index
    @announcement = Announcement.find(params[:id])
    
    if current_user.is_admin?
      @announcements = Announcement.chronological.all
    else
      @announcements = Set.new
      if current_user.is_organization_admin?
        Announcement.orgheads.each do |ann|
          @announcements.add(ann)
        end
      end
      current_user.organizations.each do |org|
        Announcement.for_org(org.id).each do |ann|
          @announcements.add(ann)
        end
      end
      Announcement.userview.each do |ann|
        @announcements.add(ann)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @announcements }
    end
  end


  def show
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @announcement }
    end
  end


  def new
    @announcement = Announcement.new
    @usr_levels = Hash[
      "Viewable by all" => User::USER_LEVELS['participant'],
      "Viewable by organization leaders and admins" => User::USER_LEVELS['organization_admin'],
      "Viewable by administrators" => User::USER_LEVELS['system_admin'] 
    ]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @announcement }
    end
  end


  def edit
    @announcement = Announcement.find(params[:id])
    @usr_levels = Hash[
      "Viewable by all" => User::USER_LEVELS['participant'],
      "Viewable by organization leaders and admins" => User::USER_LEVELS['organization_admin'],
      "Viewable by administrators" => User::USER_LEVELS['system_admin'] 
    ]
  end


  def create
    @announcement = Announcement.new(params[:announcement])
    if current_user.is_admin?
      @announcement.user_id = current_user.id
    elsif current_user.is_organization_admin?
		@announcement.organization_id = current_user.org_ids
		@announcement.user_id = current_user.id
		@announcement.level = 10

    end
    if @announcement.organization_id == nil
      @announcement.organization_id = 0
    end	
    respond_to do |format|
      if @announcement.save
        format.html { redirect_to(root_path, :notice => 'Announcement was successfully created.') }
        format.xml  { render :xml => @announcement, :status => :created, :location => @announcement }
      else
        @user_levels = Hash[
          "Viewable by participants" => User::USER_LEVELS['participant'],
          "Viewable by organization administrators" => User::USER_LEVELS['organization_admin'],
          "Viewable by system administrators" => User::USER_LEVELS['system_admin'] 
        ]
        format.html { render :action => "new" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @announcement = Announcement.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(params[:announcement])
        format.html { redirect_to(@announcement, :notice => 'Announcement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @announcement.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to(announcements_url) }
      format.xml  { head :ok }
    end
  end
end
