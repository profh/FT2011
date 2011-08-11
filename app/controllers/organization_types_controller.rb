class OrganizationTypesController < ApplicationController
  
  before_filter :login_required
  

  def index
    @organization_types = OrganizationType.alphabetical.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_types }
    end
  end


  def show
    @organization_type = OrganizationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_type }
    end
  end


  def new
    @organization_type = OrganizationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_type }
    end
  end


  def edit
    @organization_type = OrganizationType.find(params[:id])
  end


  def create
    @organization_type = OrganizationType.new(params[:organization_type])

    respond_to do |format|
      if @organization_type.save
        format.html { redirect_to(@organization_type, :notice => 'Organization type was successfully created.') }
        format.xml  { render :xml => @organization_type, :status => :created, :location => @organization_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_type.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @organization_type = OrganizationType.find(params[:id])

    respond_to do |format|
      if @organization_type.update_attributes(params[:organization_type])
        format.html { redirect_to(@organization_type, :notice => 'Organization type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_type.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @organization_type = OrganizationType.find(params[:id])
    @organization_type.destroy

    respond_to do |format|
      format.html { redirect_to(organization_types_url) }
      format.xml  { head :ok }
    end
  end
end
