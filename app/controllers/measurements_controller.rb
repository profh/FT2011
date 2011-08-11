class MeasurementsController < ApplicationController
  
  before_filter :login_required
  

  def index
    @measurements = Measurement.alphabetical.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @measurements }
    end
  end


  def show
    @measurement = Measurement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @measurement }
    end
  end


  def new
    @measurement = Measurement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @measurement }
    end
  end


  def edit
    @measurement = Measurement.find(params[:id])
  end


  def create
    @measurement = Measurement.new(params[:measurement])

    respond_to do |format|
      if @measurement.save
        format.html { redirect_to(@measurement, :notice => 'Measurement was successfully created.') }
        format.xml  { render :xml => @measurement, :status => :created, :location => @measurement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @measurement.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @measurement = Measurement.find(params[:id])

    respond_to do |format|
      if @measurement.update_attributes(params[:measurement])
        format.html { redirect_to(@measurement, :notice => 'Measurement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @measurement.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @measurement = Measurement.find(params[:id])
    @measurement.destroy

    respond_to do |format|
      format.html { redirect_to(measurements_url) }
      format.xml  { head :ok }
    end
  end
  
  
  # displays the results of every question which has been answered for this measurement
  def results
    @measurement = Measurement.find(params[:id])
    @questions = @measurement.questions.reject{|mq| mq.responses.empty?}
    
    if (!current_user.is_admin?)
      flash[:error] = "Sorry, you can't access this portion of the site."
      redirect_to measurements_path
    end
    
    # this is all built out in the view
    
  end
  
end
