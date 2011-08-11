class SnapshotsController < ApplicationController
  
  before_filter :login_required
  
  def index
    @snapshots = Snapshot.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @snapshots }
    end
  end

  def show
    @snapshot = Snapshot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snapshot }
    end
  end

  def new
    @snapshot = Snapshot.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snapshot }
    end
  end

  def edit
    @snapshot = Snapshot.find(params[:id])
  end

  def create
    @snapshot = Snapshot.new(params[:snapshot])

    respond_to do |format|
      if @snapshot.save
        format.html { redirect_to(@snapshot, :notice => 'Snapshot was successfully created.') }
        format.xml  { render :xml => @snapshot, :status => :created, :location => @snapshot }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snapshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @snapshot = Snapshot.find(params[:id])

    respond_to do |format|
      if @snapshot.update_attributes(params[:snapshot])
        format.html { redirect_to(@snapshot, :notice => 'Snapshot was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snapshot.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @snapshot = Snapshot.find(params[:id])
    @snapshot.destroy

    respond_to do |format|
      format.html { redirect_to(snapshots_url) }
      format.xml  { head :ok }
    end
  end
end
