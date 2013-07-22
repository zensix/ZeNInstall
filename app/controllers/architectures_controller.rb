class ArchitecturesController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /architectures
  # GET /architectures.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @architectures = Architecture.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @architectures }
    end
  end

  # GET /architectures/new
  # GET /architectures/new.json
  def new
    @architecture = Architecture.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @architecture }
    end
  end

  # GET /architectures/1/edit
  def edit
    @architecture = Architecture.find(params[:id])
  end

  # POST /architectures
  # POST /architectures.json
  def create
    @architecture = Architecture.new(params[:architecture])

    respond_to do |format|
      if @architecture.save
        format.html { redirect_to architectures_url, flash[:info]="Architecture was successfully created." }
        format.js { flash[:info]="Architecture was successfully created." }
        format.json { render json: @architecture, status: :created, location: @architecture }
      end
    end
  end

  # PUT /architectures/1
  # PUT /architectures/1.json
  def update
    @architecture = Architecture.find(params[:id])

    respond_to do |format|
      if @architecture.update_attributes(params[:architecture])
        format.html {redirect_to architectures_url, flash[:info]='Architecture was successfully updated.' }
        format.js { flash[:info]='Architecture was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @architecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /architectures/1
  # DELETE /architectures/1.json
  def destroy
    @architecture = Architecture.find(params[:id])
    @architecture.destroy
    
    @architectures = Architecture.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to architectures_url, flash[:info]='Architecture was successfully deleted.' }
      format.js { flash[:info]='Architecture was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Architecture.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
