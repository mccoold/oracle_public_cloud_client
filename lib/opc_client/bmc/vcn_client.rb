class VncClient < BmcClient
  # Request Handler is for command line calls
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  BmcInputParser.new(args)
    @options = inputparse.bmc('vncclient')
    if @options[:yaml]
      @instanceparameters = inputparse.yaml_reader(@options[:yaml])
    elsif @options[:json]
      @instnaceparameters = json_reader
    end
    attrcheck = { 'fingerprint'       => @options[:fingerprint],
                  'tenancy'        => @options[:tenancy],
                  'key_file'  => @options[:key_file]
    }
    @validate = Validator.new
    @validate.validate(@options, attrcheck)
    case @options[:action]
    when 'create_vcn'
      @instanceparameters = @instanceparameters['vcns'].at(0)
      create_vcn
    when 'create_subnet'
      @instanceparameters = @instanceparameters['vcns'].at(0)['subnets'].at(0)
      create_subnet
    when 'list_vcn'
      inputparse.formatter(list_vcn)
    when 'list_subnet'
      vcnResponse = {}
      list_vcn.each do |vcn|
        inputparse.formatter(list_subnets(vcn.id))
      end
    when 'delete'
      delete
    end
  end
    
  attr_writer :options, :validate
      
  # list mehod for vcn in a compartment
  def list_vcn
    attrcheck = {'compartment' => @options[:compartment]}
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:vnc] if @options[:vnc]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_vcns(@options[:compartment], opts)
    request.data
  end
  
  # list method for all subnets in a specific vcn
  def list_subnets(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_subnets(@options[:compartment], vcn_id, opts)
    request.data
  end
  
  # create method for new vcn in a compartment
  def create_vcn
    BmcAuthenticate.new(@options)
    opts = {}
    instance_details = AttrFinder.new(@instanceparameters)
    instance_details.options=(@options)
    instance_details.validate = @validate
    instance_details.function = 'vcn'
    instance_details.vcn  # This is only here because the SDK can not establish a connection with POST
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    vcn_details = OracleBMC::Core::Models::CreateVcnDetails.new
    vcn_details.cidr_block = @instanceparameters['vcn']['cidr_block']
    vcn_details.compartment_id = instance_details.compartment
    vcn_details.display_name = @instanceparameters['vcn']['display_name']
      puts vcn_details
    vcn_response = vcnapi.create_vcn(vcn_details, opts)
  end
  
  # create menthod for creating a new subnet in a vcn
  def create_subnet
    BmcAuthenticate.new(@options)
   # puts @instanceparameters['subnet']['cidr']
    subnet_attr = AttrFinder.new(@instanceparameters)
    subnet_attr.options=(@options)
    subnet_attr.validate = @validate
    subnet_attr .function = 'subnet'
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    subnet_details = OracleBMC::Core::Models::CreateSubnetDetails.new
    subnet_details.cidr_block = @instanceparameters['subnet']['cidr_block']
    subnet_details.compartment_id = instance_details.compartment
    subnet_details.availability_domain = instance_details.ad
    subnet_details.vcn_id = instance_details.vcn
    subnet_details.display_name = @instanceparameters['subnet']['display_name']
    subnet_response = vcnapi.create_subnet(subnet_details)
  end
  
  # deletes subnets in a VCN
  def delete_subnet
    subnet_details = AttrFinder.new(@instanceparameters)
    subnet_details.options=(@options)
    subnet_details.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_subnet(subnet_details.instance, opts)
    return 'subnet deleted'
  end
  
  def list_dhcp_options(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_dhcp_options(@options[:compartment], vcn_id, opts)
    request.data
  end
end

