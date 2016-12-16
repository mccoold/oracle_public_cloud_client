# controls operations for block storage on the next gen cloud
class BmcBlockStorageClient < BmcClient
  def initialize
    @validate = Validator.new
    @action = 'storage'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptParsing

  attr_writer :options, :validate, :instanceparameters

  # create new storage volumes on the Oracle Next Gen cloud
  def create
    instance_details = AttrFinder.new(@instanceparameters)
    instance_details.options = @options
    instance_details.validate = @validate
    instance_details.function = 'volume'
    BmcAuthenticate.new(@options)
    instance_details.vcn # This is only here because the SDK can not establish a connection with POST
    request = OracleBMC::Core::Models::CreateVolumeDetails.new
    request.availability_domain = instance_details.ad
    request.compartment_id = instance_details.compartment
    request.display_name = @instanceparameters['volume']['display_name']
    api = OracleBMC::Core::BlockstorageClient.new
    response = api.create_volume(request)
    instance_id = response.data.id
    api.get_volume(instance_id).wait_until(:lifecycle_state, OracleBMC::Core::Models::Volume::LIFECYCLE_STATE_AVAILABLE)
  end

  def list
    attrcheck = { 'compartment' => @options[:compartment] }
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:display_name] if @options[:display_name]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::BlockstorageClient.new
    request = request.list_volumes(@options[:compartment], opts)
    request.data
  end

  def delete
    inst_details = AttrFinder.new(@instanceparameters)
    inst_details.options = @options
    inst_details.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::BlockstorageClient.new
    request.delete_volume(inst_details.volume, opts)
  end
end
