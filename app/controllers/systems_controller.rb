class SystemsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /systems
  # GET /systems.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @systems = System.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @systems }
    end
  end

  # GET /systems/new
  # GET /systems/new.json
  def new
    @system = System.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @system }
    end
  end

  # GET /systems/1/edit
  def edit
    @system = System.find(params[:id])
  end

  # POST /systems
  # POST /systems.json
  def create
    @system = System.new(params[:system])

    respond_to do |format|
      if @system.save
        format.html { redirect_to systems_url, flash[:info]="System was successfully created." }
        format.js { flash[:info]="System was successfully created." }
        format.json { render json: @system, status: :created, location: @system }
      end
    end
  end

  # PUT /systems/1
  # PUT /systems/1.json
  def update
    @system = System.find(params[:id])

    respond_to do |format|
      if @system.update_attributes(params[:system])
        format.html {redirect_to systems_url, flash[:info]='System was successfully updated.' }
        format.js { flash[:info]='System was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @system.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /systems/1
  # DELETE /systems/1.json
  def destroy
    @system = System.find(params[:id])
    @system.destroy
    
    @systems = System.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to systems_url, flash[:info]='System was successfully deleted.' }
      format.js { flash[:info]='System was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   System.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
