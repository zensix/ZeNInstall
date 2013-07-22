class EngineController < ApplicationController

  def generateglobal
    logger.info "IN generateglobal"
    global= Hash.new
    tmp=Globalparameter.find(:all,:select => "name,value" )
    tmp.each { |field|
      global[field.name] = field.value
    }
    global
  end

  def renderscript( templatescript , server )
    outputscript="#{templatescript}"
    system = System.find(server[:system_id])
    site=Site.find(server[:site_id])
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
      end
    }
 
    logger.info "#{outputscript}"
    outputscript
  end

  def findipxescript( server )
    if server[:etat_id] == Etat.find_by_name("Ready to install")[:id] or server[:etat_id] == Etat.find_by_name("Encours")[:id] then
		logger.info "Serveur trouve"
		    system = System.find(server[:system_id])
        if system
		   logger.info "Systeme Trouve"
           ipxescript = Ipxescript.find_by_id(system[:ipxescript_id])
		   logger.info "#{ipxescript.name}"
		 else
           ipxescript =  Ipxescript.find_by_name("Exit")
        end
		logger.info "#{ipxescript.name}"
    else
      ipxescript =  Ipxescript.find_by_name("Exit")
    end
	ipxescript
  end 
  
  def generateipxescript( server )
	ipxescript=findipxescript( server )
    script=renderscript(ipxescript[:script],server)
    logger.info "OUT generateipxescript"
	
    script
  end


 
  def getipxescript
        logger.info "IN getipxescript"
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")
		server = Server.find_by_uuid(params[:uuid])
        if server
                server[:currentaddress] = request.remote_ip
        else
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
        logger.info "OUT #{script}"
        render :text => script
  end

  def view_server_ipxescript
        @server = Server.find(params[:id])
        @title="Script iPXE genere pour #{@server[:name]}"
		@installscriptcode=findipxescript(@server)
        @script=generateipxescript( @server )
    
        respond_to do |format|
    		format.html 
        end	

  end

# Script Installation OS

 # Genere le script de postinstallation
 # Parametre entrant UUID du server
 def generateOSinstallscript(server)
                os = System.find(server[:system_id])
                logger.info "#{os}"
                osinstallscript=Systeminstallscript.find(server[:systeminstallscript_id])
                logger.info "#{osinstallscript}"
                script=renderscript(osinstallscript[:script],server)
                script
  end

   def generatePostinstallscript(server)
                posinstallscript=Postinstallscript.find(server[:postinstallscript_id])
                logger.info "#{posinstallscript}"
                script=renderscript(posinstallscript[:script],server)
                script
  end
  
  def generateDestinationscript(server)
    logger.info "in generateDestinationscript"
      os = System.find(server[:system_id])
      sitedestination=Site.find(server[:sitedestination])
      famille=Famille.find(os[:famille_id]).name
      logger.info "Famille #{famille}"
	    script ="#!/bin/bash\n"
      if(famille == "Red Hat")
        logger.info "Generation de script de type RedHat"
        script=script+"# Configuration /etc/sysconfig/network\n"
        script=script+"cat  > /etc/sysconfig/network  << _EOF_\n"
        script=script+"NETWORKING=yes\n"
        script=script+"HOSTNAME="+server[:name]+"."+sitedestination[:dnsdomain]+"\n"
        script=script+"GATEWAY="+sitedestination[:gateway]+"\n"
        script=script+"_EOF_\n"
        script=script+"# Configuration /etc/sysconfig/network-scripts/ifcfg-eth0\n"
        script=script+"cat  > /etc/sysconfig/network-scripts/ifcfg-eth0 << _EOF_\n"
        script=script+'DEVICE="eth0"'+"\n"
        script=script+'BOOTPROTO="none"'+"\n"
        script=script+"NETMASK="+sitedestination[:netmask]+"\n"
        script=script+"IPADDR="+server[:destinationaddress]+"\n"
        script=script+"HOSTNAME="+server[:name]+"\n"
        script=script+'IPV6INIT="no"'+"\n"
        script=script+'MTU="1500"'+"\n"
        script=script+'MM_CONTROLLED="no"'+"\n"
        script=script+'ONBOOT="yes"'+"\n"
        script=script+'TYPE="Ethernet"'+"\n"
        script=script+'DNS1='+sitedestination[:dnssrv]+"\n"
        script=script+"DOMAIN="+sitedestination[:dnsdomain]+"\n"
        script=script+"_EOF_\n"
        script=script+"# Configuration /etc/hosts\n"
        script=script+"cat  > /etc/hosts << _EOF_\n"
        script=script+"127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n"
        script=script+server[:destinationaddress]+" "+server[:name]+"."+sitedestination[:dnsdomain]+" "+server[:name]+"\n"
        script=script+"_EOF_\n"       
      elsif(famille == "Debian")
        logger.info "Generation de script de type Debian"
        script=script+"# Configuration /etc/network/interfaces\n"
        script=script+"cat  > /etc/network/interfaces << _EOF_\n"
        script=script+"auto lo\niface lo inet loopback\n\n"
        script=script+"auto eth0\n"
        script=script+"iface eth0 inet static\n"
        script=script+"address "+server[:destinationaddress]+"\n"
        script=script+"netmask "+sitedestination[:netmask]+"\n"
        script=script+"gateway "+sitedestination[:gateway]+"\n"
        script=script+"_EOF_\n"  
        script=script+"# Configuration /etc/resolv.conf\n"
        script=script+"cat  > /etc/resolv.conf << _EOF_\n"
        script=script+"domain "+sitedestination[:dnsdomain]+"\n"
        script=script+"search "+sitedestination[:dnsdomain]+"\n"
        script=script+'namserver '+sitedestination[:dnssrv]+"\n"
        script=script+"_EOF_\n"  
        script=script+"# Configuration /etc/hostname\n"
        script=script+"echo "+server[:name]+" > /etc/hostname\n"
        script=script+"# Configuration /etc/hosts\n"
        script=script+"cat  > /etc/hosts << _EOF_\n"
        script=script+"127.0.0.1   localhost\n"
        script=script+server[:destinationaddress]+" "+server[:name]+"."+sitedestination[:dnsdomain]+" "+server[:name]+"\n"
        script=script+"_EOF_\n" 
      end
      script=script+'echo "End of projection script"'
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
		server[:etat_id] = Etat.find_by_name("Encours")[:id]
        server.save
        script=generateOSinstallscript(server)
        script.gsub!(/\r/,'')
        logger.info "#{script}" 
		    render :text => script
  end

  def view_server_osinstallscript
        @server = Server.find(params[:id])
		@installscriptcode=Systeminstallscript.find(@server[:systeminstallscript_id])
        @title="Installation OS de #{@server[:name]}"
        @script=generateOSinstallscript( @server )
        #@script.gsub!(/\n/,"<br>")
		
	
        respond_to do |format|
               format.html 
        end
  end

  
  def getpostconfigscript
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")

    server = Server.find_by_uuid(params[:uuid])

    if( server[:currentaddress] != request.remote_ip )
           server[:currentaddress] = request.remote_ip
        end
        if params[:mac]
                        server[:mac] = params[:mac]
        end
    server[:etat_id] = Etat.find_by_name("Postconfiguration")[:id]
      server.save
      script=generatePostinstallscript(server)
      script.gsub!(/\r/,'')
      logger.info "Modif en cours"
      logger.info "#{script}" 
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

    if( server[:currentaddress] != request.remote_ip )
           server[:currentaddress] = request.remote_ip
        end
        if params[:mac]
                        server[:mac] = params[:mac]
        end
      server[:etat_id] = Etat.find_by_name("Installed")[:id]
      server.save
      render :text => 'ok'
	 
  end

 def getdestinationscript
        params[:uuid].gsub!(/ /,"-")
        params[:uuid].gsub!(/%20/,"-")

    server = Server.find_by_uuid(params[:uuid])

    #  server[:etat_id] = Etat.find_by_name("Postconfiguration")[:id]
      script=generateDestinationscript(server)
      script.gsub!(/\r/,'')
      logger.info "#{script}" 
      render :text => script
  end

  def view_destinationscript
        @server = Server.find(params[:id])
        @title="Script de projection final du server #{@server[:name]}"
        @script=generateDestinationscript( @server )
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
