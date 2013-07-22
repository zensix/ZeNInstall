class IpxescriptsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /ipxescripts
  # GET /ipxescripts.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @ipxescripts = Ipxescript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @ipxescripts }
    end
  end

  # GET /ipxescripts/new
  # GET /ipxescripts/new.json
  def new
    @ipxescript = Ipxescript.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @ipxescript }
    end
  end

  # GET /ipxescripts/1/edit
  def edit
    @ipxescript = Ipxescript.find(params[:id])
  end

  # POST /ipxescripts
  # POST /ipxescripts.json
  def create
    @ipxescript = Ipxescript.new(params[:ipxescript])

    respond_to do |format|
      if @ipxescript.save
        format.html { redirect_to ipxescripts_url, flash[:info]="Ipxescript was successfully created." }
        format.js { flash[:info]="Ipxescript was successfully created." }
        format.json { render json: @ipxescript, status: :created, location: @ipxescript }
      end
    end
  end

  # PUT /ipxescripts/1
  # PUT /ipxescripts/1.json
  def update
    @ipxescript = Ipxescript.find(params[:id])

    respond_to do |format|
      if @ipxescript.update_attributes(params[:ipxescript])
        format.html {redirect_to ipxescripts_url, flash[:info]='Ipxescript was successfully updated.' }
        format.js { flash[:info]='Ipxescript was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ipxescript.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ipxescripts/1
  # DELETE /ipxescripts/1.json
  def destroy
    @ipxescript = Ipxescript.find(params[:id])
    @ipxescript.destroy
    
    @ipxescripts = Ipxescript.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to ipxescripts_url, flash[:info]='Ipxescript was successfully deleted.' }
      format.js { flash[:info]='Ipxescript was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Ipxescript.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
