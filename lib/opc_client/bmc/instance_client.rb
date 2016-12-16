# methods will return an array object
class InstanceClient < BmcClient
  require 'opc_client/bmc/helpers'

  include BmcHelpers::CommandLine

  def initialize
    @validate = Validator.new
  end

  # handles option parsing for this class
  def opt_parse # rubocop:disable Metrics/AbcSize
    case @options[:action]
    when 'create'
      build_looper('instances')
    when 'list'
      formatter(list)
    when 'delete'
      puts delete
    when 'get_ip'
      BmcAuthenticate.new(@options)
      attrcheck = { 'instance' => @options[:inst] }
      @validate.validate(@options, attrcheck)
      inst_details = AttrFinder.new(@instanceparameters)
      inst_details.options = @options
      inst_details.validate = @validate
      inst_ocid = inst_details.instance
      ips = list_instance_ip(@options[:compartment], inst_ocid)
      puts 'The private IP is ' + ips.at(0) + ' the public ip is ' + ips.at(1)
    when 'InstanceConsoleHistory'
      chist = InstanceConsoleHistory.new
      chist.options = @options
      chist.validate = @validate
      formatter(chist.list) 
    else
      'you have entered an incorrect value, correct values are get_ip, create, list, list_image, delete'
    end 
  end

  attr_writer :options, :validate, :instanceparameters

  # create a new bmc instance, it will wait for the instance to be completely built before returning
  def create # rubocop:disable Metrics/AbcSize
    inst_details = AttrFinder.new(@instanceparameters)
    inst_details.options = @options
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
    request.metadata = { 'ssh_authorized_keys' => ssh_public_key }
    api = OracleBMC::Core::ComputeClient.new
    response = api.launch_instance(request)
    @instance_id = response.data.id
    compartment(inst_details.compartment)
    running_instance = api.get_instance(@instance_id).wait_until(:lifecycle_state,
                                                                  OracleBMC::Core::Models::Instance::LIFECYCLE_STATE_RUNNING,
                                                                  max_interval_seconds: 5, max_wait_seconds: 300)
    if @instanceparameters['server']['attachments']
      @instanceparameters['server']['attachments'].each do |vol|
        attach(@instance_id, vol['volume'])
      end
    end
    running_instance
  end

  def compartment(comp)
    @compartment = comp
  end

  # gets the public and private IP's of any instance, returns and array of IP's
  def list_instance_ip(compartment_id, instance_id)
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    opts = { instance_id:  instance_id }
    api = OracleBMC::Core::ComputeClient.new
    vnics = api.list_vnic_attachments(compartment_id, opts)
    network = vcnapi.get_vnic(vnics.data[0].vnic_id)
    return network.data.private_ip, network.data.public_ip
  end

  # lists all instances in a container, returns JSON object
  def list
    attrcheck = { 'compartment' => @options[:compartment] }
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
    inst_details.options = @options
    inst_details.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request.terminate_instance(inst_details.instance, opts)
    request.get_instance(inst_details.instance).wait_until(:lifecycle_state,
                                                            OracleBMC::Core::Models::Instance::LIFECYCLE_STATE_TERMINATED,
                                                            max_interval_seconds: 5, max_wait_seconds: 300)
    return 'instance ' + @options[:inst] + ' deleted'
  end

  # list images in the container
  def list_image
    attrcheck = { 'compartment' => @options[:compartment] }
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:display_name] if @options[:display_name]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request = request.list_images(@options[:compartment], opts)
    request.data
  end

  # attaches an existing storage volume to a running instance
  def attach(instance_id, volume)# rubocop:disable Metrics/AbcSize
    inst_details = AttrFinder.new(@instanceparameters)
    @options[:inst] = volume
    inst_details.options = @options
    inst_details.validate = @validate
    inst_details.function = 'server'
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::Models::AttachVolumeDetails.new
    request.instance_id = instance_id
    request.type = 'iscsi'
    request.volume_id = inst_details.volume
    api = OracleBMC::Core::ComputeClient.new
    response = api.attach_volume(request, opts)
  end
end

# class to manage the console history
class InstanceConsoleHistory < BmcClient
  require 'opc_client/bmc/helpers'

  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing

  def initialize
    @validate = Validator.new
  end

  attr_writer :options, :validate, :instanceparameters
  
  # lists Console History
  def list
    attrcheck = { 'compartment' => @options[:compartment] }
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:display_name] if @options[:display_name]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::ComputeClient.new
    request = request.list_console_histories(@options[:compartment], opts)
    request.data
  end
end
