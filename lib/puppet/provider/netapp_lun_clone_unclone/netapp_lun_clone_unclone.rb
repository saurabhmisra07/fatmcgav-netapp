require 'puppet/provider/netapp'


Puppet::Type.type(:netapp_lun_clone_unclone).provide(:netapp_lun_clone_unclone, :parent => Puppet::Provider::Netapp) do
  @doc = "Manage Netapp Lun clone and deletion."
  
  confine :feature => :posix
  defaultfor :feature => :posix
 
  netapp_commands :luncreateclone      => 'lun-create-clone'
  netapp_commands :lundestroy          => 'lun-destroy'
  netapp_commands :lunclonelist        => 'lun-clone-list-info'
  
  mk_resource_methods
   
  def get_lun_clone_existence_status  

    lun_clone_exists = 'false'
    Puppet.debug("Fetching Lun clone lists information")
	begin
         result = lunclonelist("snapshot", @resource[:snapshot], "volume", @resource[:volume])
	 Puppet.debug(" Lun informations - #{result}")
	rescue   
     
	end
    if(result != nil)
         lun_clone_list = result.child_get("lun-clone-list")
         lun_clone_lists_info = lun_clone_list.children_get()

        # Itterate through the luns-clone_lists_info blocks
        lun_clone_lists_info.each do |lun_clone|
          # Pull out relevant info
           path = lun_clone.child_get_string("path")
      
            if ((path != nil) && (@resource[:name] == path))
              lun_clone_exists = 'true'
            end
	  
        end
    end
	  
    return lun_clone_exists
       
  end

  def get_create_command 
    arguments = ["parent-lun-path", @resource[:parentlunpath], "path", @resource[:name], "parent-snap", @resource[:parentsnap]]
     if @resource[:spacereservationenabled] == :true
       arguments +=["space-reservation-enabled", @resource[:spacereservationenabled] ] 
     end
	 
    return arguments
  end

  def get_destroy_command 
    arguments = ["path", @resource[:name]]
     if @resource[:force] == :true
      arguments +=["force", @resource[:force] ] 
     end
	 
    return arguments
  end
  
  def create   
    Puppet.debug("Inside create method.")
    luncreateclone(*get_create_command)
    lun_clone_exists = get_lun_clone_existence_status
    Puppet.debug("Lun cloned after executing clone operation - #{lun_clone_exists}")	
  end

  def destroy  
    Puppet.debug("Inside destroy method.")
    lundestroy(*get_destroy_command)
    lun_clone_exists = get_lun_clone_existence_status
    Puppet.debug("Lun cloned after executing unclone operation - #{lun_clone_exists}")	
  end
  
  def exists?
    Puppet.debug("Inside exists method.")
    lun_clone_exists = get_lun_clone_existence_status
    if  "#{lun_clone_exists}" == "false"
      Puppet.debug("Lun existence status before executing any clone/unclone operation - #{lun_clone_exists}")
      false
    else
      Puppet.debug("Lun existence status before executing any clone/unclone operation - #{lun_clone_exists}")
      true
    end

    end

  
end
