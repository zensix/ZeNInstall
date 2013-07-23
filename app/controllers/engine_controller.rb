class EngineController < ApplicationController

  def generateglobal
    global= Hash.new
    tmp=Globalparameter.find(:all,:select => "name,value" )
    tmp.each { |field|
      global[field.name] = field.value
    }
    global
  end
  
  def logaction( crit ,message)
	@log = Log.new
	@log.date = DateTime.current()
	@log.crit = crit
	@log.message = message
	@log.save
  end

  def renderscript( templatescript , server )
    outputscript="#{templatescript}"
    system = System.find(server[:system_id])
    site=Site.find(server[:site_id])
	sitedest=Site.find(server[:sitedestination])
    global=generateglobal
 #   boucle de remplacement
    templatescript.scan(/(<%=\s*@\w+.\w+\s*%>)/) { |m|
      logger.info "Traitement de #{m}"
      source=m[0].to_s.sub(/<%=\s*@(\w+).\w+\s*%>/,'\1')
      param=m[0].to_s.sub(/<%=\s*@\w+\.(\w+)\s*%>/,'\1')
      if source == "global" then
        logger.info "Source #{source} Param =[#{param}] Value=[#{global[param]}]"
        outputscript.sub!(m[0].to_s,global[param])
      elsif source == "server" then
        logger.info "Source #{source} Param =[#{param}] Value=[#{server[param]}]"
        outputscript.sub!(m[0].to_s,server[param])
      elsif source == "system" then
        logger.info "Source #{source} Param =[#{param}] Value=[#{system[param]}]"
        outputscript.sub!(m[0].to_s,system[param])
      elsif source == "site" then
         logger.info "Source #{source} Param =[#{param}] Value=[#{site[param]}]"
         outputscript.sub!(m[0].to_s,site[param])
      elsif source == "sitedest" then
         logger.info "Source #{source} Param =[#{param}] Value=[#{sitedest[param]}]"
         outputscript.sub!(m[0].to_s,sitedest[param])
      end
    }
 
    outputscript
  end

  def findipxescript( server )
    if server[:etat_id] == Etat.find_by_name("Ready to install")[:id] or server[:etat_id] == Etat.find_by_name("Encours")[:id] then
	    system = System.find(server[:system_id])
        if system
           ipxescript = Ipxescript.find_by_id(system[:ipxescript_id])
		 else
           ipxescript =  Ipxescript.find_by_name("Exit")
        end
    else
      ipxescript =  Ipxescript.find_by_name("Exit")
    end
	ipxescript
  end 
  
  def generateipxescript( server )
	ipxescript=findipxescript( server )
	logaction("info","Envoie du script :#{ipxescript.name} a #{server.name}")
    script=renderscript(ipxescript[:script],server)
    script
  end


 
  def getipxescript
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")
		server = Server.find_by_uuid(params[:uuid])
		logaction("info","Server: #{params[:uuid]}:Request IPXE")
        if server	
                server[:currentaddress] = request.remote_ip	
        else
				logaction("info","New host: #{params[:uuid]} : Request IPXE")
                server = Server.new()
                global = generateglobal
                ## a deporte dans le create du server

                server[:uuid] = params[:uuid]
                server[:name] = server[:uuid]
                server[:system_id] = System.find_by_name("none")
                server[:systeminstallscript_id] = Systeminstallscript.find_by_name("none")
                server[:etat_id] = Etat.find_by_name("Detect")[:id]
                server[:architecture_id] = Architecture.find_by_name("AMD64")[:id]
                server[:useproxy]=false
                server[:usedhcp]=false
                server[:site_id]=Site.find_by_name("Installation")[:id]
				server[:sitedestination]=Site.find_by_name("Installation")[:id]
                server[:currentaddress] = request.remote_ip
        end
        if params[:mac]
                server[:mac] = params[:mac]
        end
        server.save
        script=generateipxescript( server )
        render :text => script
  end

  def view_server_ipxescript
        @server = Server.find(params[:id])
        @title="Script iPXE genere pour #{@server[:name]}"
		@installscriptcode=findipxescript(@server)
        @script=generateipxescript( @server )
		logaction("info","view script");
        respond_to do |format|
    		format.html 
        end	

  end

# Script Installation OS

 # Genere le script de postinstallation
 # Parametre entrant UUID du server
 def generateOSinstallscript(server)
                os = System.find(server[:system_id])
                osinstallscript=Systeminstallscript.find(server[:systeminstallscript_id])
                script=renderscript(osinstallscript[:script],server)
                script
  end

   def generatePostinstallscript(server)
                posinstallscript=Postinstallscript.find(server[:postinstallscript_id])
                script=renderscript(posinstallscript[:script],server)
                script
  end
  

  

  def getosinstallscript
    params[:uuid].gsub!(/ /,"-")
    params[:uuid].gsub!(/%20/,"-")

    server = Server.find_by_uuid(params[:uuid])
	
    if( server[:currentaddress] != request.remote_ip )
           server[:currentaddress] = request.remote_ip
    end
    if params[:mac]
       server[:mac] = params[:mac]
    end
	logaction("info","Server: #{server.name} #{server[:currentaddress]} :Request OS")
	server[:etat_id] = Etat.find_by_name("Encours")[:id]
    server.save
	if( server[:configlock] == false )

		script=generateOSinstallscript(server)
		script= "### Generation ZeNInstalle en date du : " + Time.now.to_s + "###\n" + script
		server[:lastgeneratedinstallscript] = script;
		script.gsub!(/\r/,'')
		server.save
	else
		logaction("info","Envoie de la configuration statique a  #{server.name}")
		script=server[:lastgeneratedinstallscript]
	end
    
	logger.info "#{script}" 
	render :text => script
  end

  def view_server_osinstallscript
        @server = Server.find(params[:id])
		@installscriptcode=Systeminstallscript.find(@server[:systeminstallscript_id])
        @title="Installation OS de #{@server[:name]}"
        @script=generateOSinstallscript( @server )
	
        respond_to do |format|
               format.html 
        end
  end

  
  def getpostconfigscript
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")

    server = Server.find_by_uuid(params[:uuid])
    logaction("info","Server: #{server.name} #{server[:currentaddress]} :Request Postconfiguration")
    if( server[:currentaddress] != request.remote_ip )
        server[:currentaddress] = request.remote_ip
    end
    if params[:mac]
        server[:mac] = params[:mac]
    end
    server[:etat_id] = Etat.find_by_name("Postconfiguration")[:id]
    server.save
	
   	if( server[:configlock] == false ) 
		script=generatePostinstallscript(server)
		server[:lastgeneratedpostinstallsctipt]=script
		server.save
		script.gsub!(/\r/,'')
	else
		script=server[:lastgeneratedpostinstallsctipt]
	end
 	render :text => script
  end

  def view_server_postconfigscript
	    @server = Server.find(params[:id])
        @title="PostConfiguration OS de #{@server[:name]}"
		@installscriptcode=Postinstallscript.find(@server[:postinstallscript_id])
        @script=generatePostinstallscript( @server )
		
        respond_to do |format|
                format.html 
        end
   end

  def setstatusfinish
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")

    server = Server.find_by_uuid(params[:uuid])
     logaction("info","Server: #{server.name} #{server[:currentaddress]} :Send Install finish")
    if( server[:currentaddress] != request.remote_ip )
           server[:currentaddress] = request.remote_ip
        end
        if params[:mac]
                        server[:mac] = params[:mac]
        end
      server[:log_id] = Etat.find_by_name("Installed")[:id]
      server.save
      render :text => 'ok'
	 
  end

 def getprojectionscript
      params[:uuid].gsub!(/ /,"-")
      params[:uuid].gsub!(/%20/,"-")
      @server = Server.find_by_uuid(params[:uuid])
	  
      script=generateprojectionscript(@server)
      script.gsub!(/\r/,'')
      logger.info "#{script}" 
	 
      render :text => script
  end

    def generateprojectionscript(server)
  		@famille=Famille.find(System.find(@server[:system_id]))
		@projectionscript=Projectionscript.find(@famille.script)
        script=renderscript(@projectionscript[:script],server)
        script
  end
  
   def view_server_projectionscript
        @server = Server.find(params[:id])
        @title="Script de projection final du server #{@server[:name]}"
	#	@os=System.find(@server[:system_id])
	#	@famille=Famille.find(@os[:famille_id])
		@famille=Famille.find(System.find(@server[:system_id]))
		logger.info "Trouve #{@famille.name}" 
		@scriptcode=Projectionscript.find(@famille.script)
		@script=generateprojectionscript( @server )
        respond_to do |format|
                format.html
        end
   end


   def test
	
     @data="toto"
         respond_to do |format|
				format.js
         end
   end	

end
