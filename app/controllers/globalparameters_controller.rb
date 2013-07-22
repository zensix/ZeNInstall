class GlobalparametersController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /globalparameters
  # GET /globalparameters.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @globalparameters = Globalparameter.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @globalparameters }
    end
  end

  # GET /globalparameters/new
  # GET /globalparameters/new.json
  def new
    @globalparameter = Globalparameter.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @globalparameter }
    end
  end

  # GET /globalparameters/1/edit
  def edit
    @globalparameter = Globalparameter.find(params[:id])
  end

  # POST /globalparameters
  # POST /globalparameters.json
  def create
    @globalparameter = Globalparameter.new(params[:globalparameter])

    respond_to do |format|
      if @globalparameter.save
        format.html { redirect_to globalparameters_url, flash[:info]="Globalparameter was successfully created." }
        format.js { flash[:info]="Globalparameter was successfully created." }
        format.json { render json: @globalparameter, status: :created, location: @globalparameter }
      end
    end
  end

  # PUT /globalparameters/1
  # PUT /globalparameters/1.json
  def update
    @globalparameter = Globalparameter.find(params[:id])

    respond_to do |format|
      if @globalparameter.update_attributes(params[:globalparameter])
        format.html {redirect_to globalparameters_url, flash[:info]='Globalparameter was successfully updated.' }
        format.js { flash[:info]='Globalparameter was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @globalparameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /globalparameters/1
  # DELETE /globalparameters/1.json
  def destroy
    @globalparameter = Globalparameter.find(params[:id])
    @globalparameter.destroy
    
    @globalparameters = Globalparameter.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to globalparameters_url, flash[:info]='Globalparameter was successfully deleted.' }
      format.js { flash[:info]='Globalparameter was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Globalparameter.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
