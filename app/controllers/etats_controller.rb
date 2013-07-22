class EtatsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /etats
  # GET /etats.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @etats = Etat.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @etats }
    end
  end

  # GET /etats/new
  # GET /etats/new.json
  def new
    @etat = Etat.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @etat }
    end
  end

  # GET /etats/1/edit
  def edit
    @etat = Etat.find(params[:id])
  end

  # POST /etats
  # POST /etats.json
  def create
    @etat = Etat.new(params[:etat])

    respond_to do |format|
      if @etat.save
        format.html { redirect_to etats_url, flash[:info]="Etat was successfully created." }
        format.js { flash[:info]="Etat was successfully created." }
        format.json { render json: @etat, status: :created, location: @etat }
      end
    end
  end

  # PUT /etats/1
  # PUT /etats/1.json
  def update
    @etat = Etat.find(params[:id])

    respond_to do |format|
      if @etat.update_attributes(params[:etat])
        format.html {redirect_to etats_url, flash[:info]='Etat was successfully updated.' }
        format.js { flash[:info]='Etat was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @etat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etats/1
  # DELETE /etats/1.json
  def destroy
    @etat = Etat.find(params[:id])
    @etat.destroy
    
    @etats = Etat.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to etats_url, flash[:info]='Etat was successfully deleted.' }
      format.js { flash[:info]='Etat was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Etat.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
