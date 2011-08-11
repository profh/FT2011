class OrganizationUsersController < ApplicationController
  
  before_filter :login_required
  

  def index
    @organization_users = OrganizationUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_users }
    end
  end


  def show
    @organization_user = OrganizationUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_user }
    end
  end


  def new
    @organization_user = OrganizationUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_user }
    end
  end


  def edit
    @organization_user = OrganizationUser.find(params[:id])
  end


  def create
    @organization_user = OrganizationUser.new(params[:organization_user])

    respond_to do |format|
      if @organization_user.save
        format.html { redirect_to(@organization_user, :notice => 'Organization user was successfully created.') }
        format.xml  { render :xml => @organization_user, :status => :created, :location => @organization_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @organization_user = OrganizationUser.find(params[:id])

    respond_to do |format|
      if @organization_user.update_attributes(params[:organization_user])
        format.html { redirect_to(@organization_user, :notice => 'Organization user was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @organization_user = OrganizationUser.find(params[:id])
    @organization_user.destroy

    respond_to do |format|
      format.html { redirect_to(organization_users_url) }
      format.xml  { head :ok }
    end
  end
end
