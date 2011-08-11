class OrganizationsController < ApplicationController
  
  before_filter :login_required
  

  def index
    @organizations = Organization.alphabetical.all
    @org_users = Set.new
	  current_user.organizations.each {|o| @org_users += o.users}
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizations }
    end
  end


  def show
    @organization = Organization.find(params[:id])
    @organizations = Organization.all
	  @participants = @organization.users.completep

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization }
    end
  end


  def new
    @organization = Organization.new
    @orgtype = OrganizationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization }
    end
  end


  def edit
    @organization = Organization.find(params[:id])
  end


  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to(@organization, :notice => 'Organization was successfully created.') }
        format.xml  { render :xml => @organization, :status => :created, :location => @organization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to(@organization, :notice => 'Organization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end
  
  # All organizations
  def all 
	  @organizations_all = Organization.alphabetical.all
  end
  
end
