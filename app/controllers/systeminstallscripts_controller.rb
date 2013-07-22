class SysteminstallscriptsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /systeminstallscripts
  # GET /systeminstallscripts.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @systeminstallscripts = Systeminstallscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @systeminstallscripts }
    end
  end

  # GET /systeminstallscripts/new
  # GET /systeminstallscripts/new.json
  def new
    @systeminstallscript = Systeminstallscript.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @systeminstallscript }
    end
  end

  # GET /systeminstallscripts/1/edit
  def edit
    @systeminstallscript = Systeminstallscript.find(params[:id])
  end

  # POST /systeminstallscripts
  # POST /systeminstallscripts.json
  def create
    @systeminstallscript = Systeminstallscript.new(params[:systeminstallscript])

    respond_to do |format|
      if @systeminstallscript.save
        format.html { redirect_to systeminstallscripts_url, flash[:info]="Systeminstallscript was successfully created." }
        format.js { flash[:info]="Systeminstallscript was successfully created." }
        format.json { render json: @systeminstallscript, status: :created, location: @systeminstallscript }
      end
    end
  end

  # PUT /systeminstallscripts/1
  # PUT /systeminstallscripts/1.json
  def update
    @systeminstallscript = Systeminstallscript.find(params[:id])

    respond_to do |format|
      if @systeminstallscript.update_attributes(params[:systeminstallscript])
        format.html {redirect_to systeminstallscripts_url, flash[:info]='Systeminstallscript was successfully updated.' }
        format.js { flash[:info]='Systeminstallscript was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @systeminstallscript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /systeminstallscripts/1
  # DELETE /systeminstallscripts/1.json
  def destroy
    @systeminstallscript = Systeminstallscript.find(params[:id])
    @systeminstallscript.destroy
    
    @systeminstallscripts = Systeminstallscript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to systeminstallscripts_url, flash[:info]='Systeminstallscript was successfully deleted.' }
      format.js { flash[:info]='Systeminstallscript was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Systeminstallscript.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
