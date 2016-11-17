# finds the OCID's for objects in the BMC cloud
class AttrFinder < BmcClient
  def initialize(env)
    @env = env
   # compartmentId = OracleBMC.config.tenancy
  end

  attr_writer :options, :validate, :function

  # gets compartment ocid's
  def compartment
    identityapi = OracleBMC::Identity::IdentityClient.new
    compartments = identityapi.list_compartments(OracleBMC.config.tenancy)
    compartmentId = nil
    compartments.data.each do |compartment|
      if compartment.name.include?(@env[@function]['compartment'])
        compartmentId = compartment.id
      end
    end
    compartmentId
  end

  # get vcn ocid's
  def vcn
    vncdata = VncClient.new
    @options[:vcn] = @env[@function]['vcn']  
    vncdata.options= @options
    vncdata.validate = @validate
    vncresponse = vncdata.list_vcn
    instance_vcn = nil
    vncresponse.each do |vcn|
      instance_vcn = vcn.id if vcn.display_name == @env[@function]['vcn']
    end
    instance_vcn
  end

  # get subnet ocid's
  def subnet
    vcn
    subnetdata = VncClient.new
    subnetdata.options= @options 
    subnetdata.validate = @validate
    vcnlist = subnetdata.list_subnets(vcn)
    instance_subnet=nil
    vcnlist.each do |vcns|
    instance_subnet = vcns.id if vcns.display_name == @env[@function]['subnet']
    end
    instance_subnet
  end
  
  # get ad ocid's
  def ad
    adresponse = IdentityClient.new
    adresponse.options= @options 
    adresponse.validate = @validate
    adresponse = adresponse.ad_list
    instance_ad = nil
    adresponse.each do |ad|
      if ad.name.include?(@env[@function]['ad'])
        instance_ad = ad.name
      end
    end
    instance_ad
  end
  
  # gets image ocid's
  def image
    imageResponse = InstanceClient.new
    imageResponse.options= @options 
    imageResponse.validate = @validate
    imageResponse = imageResponse.list_image
    imageID = nil
    imageResponse.each do |image|
      if image.display_name.include?(@env['server']['image'])
        imageID = image.id
      end
    end
    imageID
  end
  
  # gets instance ocid's
  def instance
    instanceResponse = InstanceClient.new
    instanceResponse.options= @options 
    instanceResponse.validate = @validate
    instanceResponse = instanceResponse.list
    instanceID = nil
    instanceResponse.each do |instances|
      if instances.display_name.include?(@options[:inst])
        instanceID = instances.id
      end
    end
   instanceID
  end
  
  def volume
    volumeResponse = InstanceClient.new
    volumeResponse.options= @options 
    volumeResponse.validate = @validate
    volumeResponse = instanceResponse.list
    volumeID = nil
    volumeResponse.each do |volumes|
        if volumes.display_name.include?(@options[:inst])
          volumeID = volume.id
        end
      end
    volumeID
    end 
end
