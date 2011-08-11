class IdCardsController < ApplicationController
  
  before_filter :login_required
  
  # GET /id_cards
  # GET /id_cards.xml
  def index
    @id_cards = IdCard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @id_cards }
    end
  end

  # GET /id_cards/1
  # GET /id_cards/1.xml
  def show
    @id_card = IdCard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @id_card }
    end
  end

  # GET /id_cards/new
  # GET /id_cards/new.xml
  def new
    @id_card = IdCard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @id_card }
    end
  end

  # GET /id_cards/1/edit
  def edit
    @id_card = IdCard.find(params[:id])
  end

  # POST /id_cards
  # POST /id_cards.xml
  def create
    @id_card = IdCard.new(params[:id_card])

    respond_to do |format|
      if @id_card.save
        format.html { redirect_to(@id_card, :notice => 'Id card was successfully created.') }
        format.xml  { render :xml => @id_card, :status => :created, :location => @id_card }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @id_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /id_cards/1
  # PUT /id_cards/1.xml
  def update
    @id_card = IdCard.find(params[:id])

    respond_to do |format|
      if @id_card.update_attributes(params[:id_card])
        format.html { redirect_to(@id_card, :notice => 'Id card was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @id_card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /id_cards/1
  # DELETE /id_cards/1.xml
  def destroy
    @id_card = IdCard.find(params[:id])
    @id_card.destroy

    respond_to do |format|
      format.html { redirect_to(id_cards_url) }
      format.xml  { head :ok }
    end
  end
end
