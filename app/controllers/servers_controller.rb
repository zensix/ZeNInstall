class ServersController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /servers
  # GET /servers.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @servers = Server.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @servers }
    end
  end

  # GET /servers/new
  # GET /servers/new.json
  def new
    @server = Server.new

    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @server }
    end
  end

  # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
  end

  # POST /servers
  # POST /servers.json
  def create
    @server = Server.new(params[:server])

    respond_to do |format|
      if @server.save
        format.html { redirect_to servers_url, flash[:info]="Server was successfully created." }
        format.js { flash[:info]="Server was successfully created." }
        format.json { render json: @server, status: :created, location: @server }
      end
    end
  end

  # PUT /servers/1
  # PUT /servers/1.json
  def update
    @server = Server.find(params[:id])

    respond_to do |format|
      if @server.update_attributes(params[:server])
        format.html {redirect_to servers_url, flash[:info]='Server was successfully updated.' }
        format.js { flash[:info]='Server was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server = Server.find(params[:id])
    @server.destroy
    
    @servers = Server.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to servers_url, flash[:info]='Server was successfully deleted.' }
      format.js { flash[:info]='Server was successfully deleted.' }
      format.json { head :ok }
    end
  end
 
  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Server.column_names.include?(params[:sort]) ? params[:sort] : "name"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
