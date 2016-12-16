# finds the OCID's for objects in the BMC cloud
class AttrFinder < BmcClient
  def initialize(env)
    @env = env
    @param = 'display_name'
  end

  attr_writer :options, :validate, :function, :compartment, :param

  # gets compartment ocid's
  def compartment
    identityapi = OracleBMC::Identity::IdentityClient.new
    compartments = identityapi.list_compartments(OracleBMC.config.tenancy)
    compartment_id = nil
    compartments.data.each do |compartment|
      if compartment.name.include?(@env[@function]['compartment'])
        compartment_id = compartment.id
      elsif compartment.name.include?(@compartment)
        compartment_id = compartment.id
      end
    end
    compartment_id
  end

  # get vcn ocid's
  def vcn
    vcndata = VcnClient.new
    @options[:vcn] = @env[@function]['vcn'] unless @env.nil? || @env[@function].nil?  
    vcndata.options = @options
    vcndata.validate = @validate
    vcnresponse = vcndata.list
    instance_vcn = nil
    vcnresponse.each do |vcn|
      instance_vcn = vcn.id if vcn.display_name == @options[:vcn]
    end
    instance_vcn
  end

  # get subnet ocid's
  def subnet # rubocop:disable Metrics/AbcSize
    vcn
    return nil if vcn.nil?
    subnetdata = SubnetClient.new
    subnetdata.options = @options
    subnetdata.validate = @validate
    vcnlist = subnetdata.list(vcn)
    @options[:inst] = @env[@function]['subnet'] unless @env.nil? || @env[@function].nil?
    instance_subnet = nil
    vcnlist.each do |vcns|
      instance_subnet = vcns.id if vcns.display_name == @options[:inst]
    end
    instance_subnet
  end

  # get ad ocid's
  def ad
    adresponse = IdentityClient.new
    adresponse.options = @options
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
    image_response = InstanceClient.new
    image_response.options = @options
    image_response.validate = @validate
    image_response = image_response.list_image
    image_id = nil
    image_response.each do |image|
      if image.display_name.include?(@env['server']['image'])
        image_id = image.id
      end
    end
    image_id
  end

  # gets instance ocid's
  def instance
    instance_response = InstanceClient.new
    instance_response.options = @options
    instance_response.validate = @validate
    instance_response = instance_response.list
    instance_id = nil
    instance_response.each do |instances|
      if instances.display_name.include?(@options[:inst])
        instance_id = instances.id unless instances.lifecycle_state == 'TERMINATED'
      end
    end
    instance_id
  end

  # secondary name for instance
  def server
    instance
  end

  # get ocid for volumes
  def volume
    volume_response = BmcBlockStorageClient.new
    volume_response.options = @options
    volume_response.validate = @validate
    volume_response = volume_response.list
    volume_id = nil
    volume_response.each do |volumes|
      if volumes.display_name.include?(@options[:inst]) && volumes.lifecycle_state == 'AVAILABLE'
        volume_id = volumes.id
      end
    end
    volume_id
  end

  # gets ocid for the internet gateway
  def gateway # rubocop:disable Metrics/AbcSize
    vcn
    return nil if vcn.nil?
    @options[:inst] = @env[@function][@param] unless @env.nil? || @env[@function].nil?
    gatewaydata = InternetGateway.new
    gatewaydata.options = @options
    gatewaydata.validate = @validate
    vcnlist = gatewaydata.list(vcn)
    instance_gateway = nil
    vcnlist.each do |vcns|
      instance_gateway = vcns.id if vcns.display_name == (@options[:inst])
    end
    instance_gateway
  end
  
  def internet_gateway
    gateway
  end

  def security_list # rubocop:disable Metrics/AbcSize
    vcn
    return nil if vcn.nil?
    @options[:inst] = @env[@function][@param] unless @env.nil? || @env[@function].nil?
    sl_data = SecurityListClient.new
    sl_data.options = @options
    sl_data.validate = @validate
    vcnlist = sl_data.list(vcn)
    sl_instance = nil
    vcnlist.each do |vcns|
      sl_instance = vcns.id if vcns.display_name == (@options[:inst])
    end
    sl_instance
  end
    
  def route # rubocop:disable Metrics/AbcSize
    vcn
    return nil if vcn.nil?
    @options[:inst] = @env[@function][@param] unless @env.nil? || @env[@function].nil?
    routedata = RouteClient.new
    routedata.options = @options
    routedata.validate = @validate
    vcnlist = routedata.list(vcn)
    route = nil
    vcnlist.each do |vcns|
      route = vcns.id if vcns.display_name == (@options[:inst])
    end
    route
  end

  def route_table
    route
  end
  
  def dhcp # rubocop:disable Metrics/AbcSize
    vcn
    return nil if vcn.nil?
    @options[:inst] = @env[@function]['display_name'] unless @env.nil? || @env[@function].nil?
    dhcpdata = DHCPClient.new
    dhcpdata.options = @options
    dhcpdata.validate = @validate
    vcnlist = dhcpdata.list(vcn)
    dhcp = nil
    vcnlist.each do |vcns|
      dhcp = vcns.id if vcns.display_name == (@options[:inst])
    end
    dhcp
  end
end
