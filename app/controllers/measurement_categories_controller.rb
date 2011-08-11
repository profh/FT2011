class MeasurementCategoriesController < ApplicationController
  
  before_filter :login_required
  

  def index
    @measurement_categories = MeasurementCategory.alphabetical.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @measurement_categories }
    end
  end


  def show
    @measurement_category = MeasurementCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @measurement_category }
    end
  end


  def new
    @measurement_category = MeasurementCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @measurement_category }
    end
  end


  def edit
    @measurement_category = MeasurementCategory.find(params[:id])
  end


  def create
    @measurement_category = MeasurementCategory.new(params[:measurement_category])

    respond_to do |format|
      if @measurement_category.save
        format.html { redirect_to(@measurement_category, :notice => 'Measurement category was successfully created.') }
        format.xml  { render :xml => @measurement_category, :status => :created, :location => @measurement_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @measurement_category.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @measurement_category = MeasurementCategory.find(params[:id])

    respond_to do |format|
      if @measurement_category.update_attributes(params[:measurement_category])
        format.html { redirect_to(@measurement_category, :notice => 'Measurement category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @measurement_category.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @measurement_category = MeasurementCategory.find(params[:id])
    @measurement_category.destroy

    respond_to do |format|
      format.html { redirect_to(measurement_categories_url) }
      format.xml  { head :ok }
    end
  end
end
