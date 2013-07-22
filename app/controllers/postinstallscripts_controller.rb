class PostinstallscriptsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /postinstallscripts
  # GET /postinstallscripts.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @postinstallscripts = Postinstallscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @postinstallscripts }
    end
  end

  # GET /postinstallscripts/new
  # GET /postinstallscripts/new.json
  def new
    @postinstallscript = Postinstallscript.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @postinstallscript }
    end
  end

  # GET /postinstallscripts/1/edit
  def edit
    @postinstallscript = Postinstallscript.find(params[:id])
  end

  # POST /postinstallscripts
  # POST /postinstallscripts.json
  def create
    @postinstallscript = Postinstallscript.new(params[:postinstallscript])

    respond_to do |format|
      if @postinstallscript.save
        format.html { redirect_to postinstallscripts_url, flash[:info]="Postinstallscript was successfully created." }
        format.js { flash[:info]="Postinstallscript was successfully created." }
        format.json { render json: @postinstallscript, status: :created, location: @postinstallscript }
      end
    end
  end

  # PUT /postinstallscripts/1
  # PUT /postinstallscripts/1.json
  def update
    @postinstallscript = Postinstallscript.find(params[:id])

    respond_to do |format|
      if @postinstallscript.update_attributes(params[:postinstallscript])
        format.html {redirect_to postinstallscripts_url, flash[:info]='Postinstallscript was successfully updated.' }
        format.js { flash[:info]='Postinstallscript was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @postinstallscript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postinstallscripts/1
  # DELETE /postinstallscripts/1.json
  def destroy
    @postinstallscript = Postinstallscript.find(params[:id])
    @postinstallscript.destroy
    
    @postinstallscripts = Postinstallscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to postinstallscripts_url, flash[:info]='Postinstallscript was successfully deleted.' }
      format.js { flash[:info]='Postinstallscript was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Postinstallscript.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
