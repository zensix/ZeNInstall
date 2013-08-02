class CodemodulesController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /codemodules
  # GET /codemodules.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @codemodules = Codemodule.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @codemodules }
    end
  end

  # GET /codemodules/new
  # GET /codemodules/new.json
  def new
    @codemodule = Codemodule.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @codemodule }
    end
  end

  # GET /codemodules/1/edit
  def edit
    @codemodule = Codemodule.find(params[:id])
  end

  # POST /codemodules
  # POST /codemodules.json
  def create
    @codemodule = Codemodule.new(params[:codemodule])

    respond_to do |format|
      if @codemodule.save
        format.html { redirect_to codemodules_url, flash[:info]="module was successfully created." }
        format.js { flash[:info]="module was successfully created." }
        format.json { render json: @codemodule, status: :created, location: @codemodule }
      end
    end
  end

  # PUT /codemodules/1
  # PUT /codemodules/1.json
  def update
    @codemodule = Codemodule.find(params[:id])

    respond_to do |format|
      if @codemodule.update_attributes(params[:codemodule])
        format.html {redirect_to codemodules_url, flash[:info]='module was successfully updated.' }
        format.js { flash[:info]='module was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @codemodule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /codemodules/1
  # DELETE /codemodules/1.json
  def destroy
    @codemodule = Codemodule.find(params[:id])
    @codemodule.destroy
    
    @codemodules = Codemodule.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to codemodules_url, flash[:info]='module was successfully deleted.' }
      format.js { flash[:info]='module was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Codemodule.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
