class FamillesController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /familles
  # GET /familles.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @familles = Famille.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @familles }
    end
  end

  # GET /familles/new
  # GET /familles/new.json
  def new
    @famille = Famille.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @famille }
    end
  end

  # GET /familles/1/edit
  def edit
    @famille = Famille.find(params[:id])
  end

  # POST /familles
  # POST /familles.json
  def create
    @famille = Famille.new(params[:famille])

    respond_to do |format|
      if @famille.save
        format.html { redirect_to familles_url, flash[:info]="Famille was successfully created." }
        format.js { flash[:info]="Famille was successfully created." }
        format.json { render json: @famille, status: :created, location: @famille }
      end
    end
  end

  # PUT /familles/1
  # PUT /familles/1.json
  def update
    @famille = Famille.find(params[:id])

    respond_to do |format|
      if @famille.update_attributes(params[:famille])
        format.html {redirect_to familles_url, flash[:info]='Famille was successfully updated.' }
        format.js { flash[:info]='Famille was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @famille.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /familles/1
  # DELETE /familles/1.json
  def destroy
    @famille = Famille.find(params[:id])
    @famille.destroy
    
    @familles = Famille.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to familles_url, flash[:info]='Famille was successfully deleted.' }
      format.js { flash[:info]='Famille was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Famille.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
