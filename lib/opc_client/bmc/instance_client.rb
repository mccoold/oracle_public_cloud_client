
# methods will return an array object 
class InstanceClient < BmcClient
  # Request Handler is for command line calls
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  BmcInputParser.new(args)
    @options = inputparse.bmc('instanceclient')
    if @options[:yaml]
      @instanceparameters = inputparse.yaml_reader(@options[:yaml])
    elsif @options[:json]
      @instnaceparameters = json_reader
    end
    attrcheck = { 'fingerprint'  => @options[:fingerprint],
                  'tenancy'      => @options[:tenancy],
                  'key_file'     => @options[:key_file]
    }
    @validate = Validator.new
    @validate.validate(@options, attrcheck)
    case @options[:action]
    when 'create'
      @instanceparameters = @instanceparameters['compute'].at(0)
      create_results = create
      "Success!! Server Is Available - Public Ip: " +   create_results.at(1) + " and Private Ip: " +
      create_results.at(0)
    when 'list'
      inputparse.formatter(list)
    when 'delete'
      delete
    when 'get_ip'
      BmcAuthenticate.new(@options)
      inst_details = AttrFinder.new(@instanceparameters)
      inst_details.options=(@options)
      inst_details.validate = @validate
      inst_ocid = inst_details.instance
      ips = list_instance_ip(@options[:compartment], inst_ocid)
      return 'The private IP is ' + ips.at(0) + ' the public ip is ' + ips.at(1)
    else
      'you have entered an incorrect value, correct values are get_ip, create, list, list_image, delete'
    end
  end
  
  attr_writer :options, :validate, :instanceparameters
  
  # create a new bmc instance, it will wait for the instance to be completely built before returning
  def create
    inst_details = AttrFinder.new(@instanceparameters)
    inst_details.options=(@options)
    inst_details.validate = @validate
    inst_details.function = 'server'
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::Models::LaunchInstanceDetails.new
    ssh_public_key = @instanceparameters['server']['ssh-key']
    request.availability_domain = inst_details.ad
    request.compartment_id = inst_details.compartment
    request.display_name = @instanceparameters['server']['display_name']
    request.image_id = inst_details.image
    request.shape = @instanceparameters['server']['shape']
    request.subnet_id = inst_details.subnet 
    request.metadata = {'ssh_authorized_keys' => ssh_public_key}
    api = OracleBMC::Core::ComputeClient.new
    response = api.launch_instance(request)
    instance_id = response.data.id
    response = api.get_instance(instance_id).wait_until(:lifecycle_state,
                                                        OracleBMC::Core::Models::Instance::LIFECYCLE_STATE_RUNNING,
                                                        max_interval_seconds: 5, max_wait_seconds: 300)
    network = list_instance_ip(inst_details.compartment, instance_id)
    #return network.data.public_ip, network.data.private_ip
    #rescue OracleBMC::Errors::ServiceError => e
    # wait_until might throw timeout or other errors.
  end

  # gets the public and private IP's of any instance
  def list_instance_ip(compartmentId, instance_id)
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    opts = { instance_id:  instance_id }
    api = OracleBMC::Core::ComputeClient.new
    vnics = api.list_vnic_attachments(compartmentId, opts)
    puts vnics.data[0].vnic_id
    network = vcnapi.get_vnic(vnics.data[0].vnic_id)
    return network.data.private_ip, network.data.public_ip
  end
  
  # lists all instances in a container
  def list
    attrcheck = {'compartment' => @options[:compartment]}
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:display_name] if @options[:display_name]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request = request.list_instances(@options[:compartment], opts)
    request.data
  end
  
  # deletes an instance
  def delete 
    inst_details = AttrFinder.new(@instanceparameters)
    inst_details.options=(@options)
    inst_details.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request.terminate_instance(inst_details.instance, opts)
    return 'instance deleted'
  end
  
  # list images in the container
  def list_image
    attrcheck = {'compartment' => @options[:compartment]}
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:display_name] if @options[:display_name]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request = request.list_images(@options[:compartment], opts)
    request.data
  end
end