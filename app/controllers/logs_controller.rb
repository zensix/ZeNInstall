class LogsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  # GET /logs
  # GET /logs.json
  def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    @logs = Log.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @logs }
    end
  end

  
  # sort icin default column
  private  
  def sort_column
   # column varmi diye kontrol ediliyor, yoksa name default   
   Log.column_names.include?(params[:sort]) ? params[:sort] : "date"   
  end  
 
  # sort icin default direction asc
  def sort_direction
    # karakter kontrol yapiliyor security icin  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"    
  end    
end
