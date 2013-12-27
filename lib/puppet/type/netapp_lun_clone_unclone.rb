Puppet::Type.newtype(:netapp_lun_clone_unclone) do 
  @doc = "Manage Netapp Lun clone and deletion."
  
  apply_to_device
  
  ensurable
  
  newparam(:name) do
    desc "The volume name. Valid characters are a-z, 1-9 & underscore."
  end

  newparam(:parentlunpath) do  
  end
  
  newparam(:parentsnap) do  
  end
  
  newparam(:snapshot) do  
  end
  
  newparam(:volume) do
  end

  newparam(:spacereservationenabled, :boolean => false) do
    newvalues(:true, :false)
    defaultto :false
  end

  newparam(:force, :boolean => false) do
    newvalues(:true, :false)
    defaultto :false
  end
  
end
