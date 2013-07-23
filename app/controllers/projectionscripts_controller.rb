class ProjectionscriptsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /projectionscripts
  # GET /projectionscripts.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @projectionscripts = Projectionscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @projectionscripts }
    end
  end

  # GET /projectionscripts/new
  # GET /projectionscripts/new.json
  def new
    @projectionscript = Projectionscript.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @projectionscript }
    end
  end

  # GET /projectionscripts/1/edit
  def edit
    @projectionscript = Projectionscript.find(params[:id])
  end

  # POST /projectionscripts
  # POST /projectionscripts.json
  def create
    @projectionscript = Projectionscript.new(params[:projectionscript])

    respond_to do |format|
      if @projectionscript.save
        format.html { redirect_to projectionscripts_url, flash[:info]="Projectionscript was successfully created." }
        format.js { flash[:info]="Projectionscript was successfully created." }
        format.json { render json: @projectionscript, status: :created, location: @projectionscript }
      end
    end
  end

  # PUT /projectionscripts/1
  # PUT /projectionscripts/1.json
  def update
    @projectionscript = Projectionscript.find(params[:id])

    respond_to do |format|
      if @projectionscript.update_attributes(params[:projectionscript])
        format.html {redirect_to projectionscripts_url, flash[:info]='Projectionscript was successfully updated.' }
        format.js { flash[:info]='Projectionscript was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @projectionscript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projectionscripts/1
  # DELETE /projectionscripts/1.json
  def destroy
    @projectionscript = Projectionscript.find(params[:id])
    @projectionscript.destroy
    
    @projectionscripts = Projectionscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to projectionscripts_url, flash[:info]='Projectionscript was successfully deleted.' }
      format.js { flash[:info]='Projectionscript was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Projectionscript.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
