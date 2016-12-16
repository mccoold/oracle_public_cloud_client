# this class allows you to create entire ecosystems or stacks via yaml file.
# The parsing of the file is not brittle, if something is already there it will skip it
class EcoSystem < BmcClient
  def initialize
    @validate = Validator.new
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine

  attr_writer :options, :validate, :instanceparameters

  # opt parsing for vcn
  def opt_parse # rubocop:disable Metrics/AbcSize
    case @options[:action]
    when 'create'
      puts ''
      puts 'Provisioning VCNs'
      build_looper('vcns')
      puts 'VCNs Provisioning Complete'
      puts ''
      puts 'Provioning Gateways Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('internet_gateways')
      puts 'Internet gateways Provisioning Complete'
      puts ''
      puts 'Provioning Routes Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('route_tables')
      puts 'Route Provisioning Complete'
      puts ''
      puts 'Provioning Security Lists Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('security_lists')
      puts 'Security Lists Provisioning Complete'
      puts ''
      puts 'Subnet Provioning Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('subnets')
      puts 'Subnet Provionsing Complete'
      puts ''
      puts 'Provioning Storage Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('storage')
      puts 'Storage Provisioning Complete'
      puts ''
      puts 'Provioning Instances Starting'
      @instanceparameters = yaml_reader(@options[:yaml])
      build_looper('instances') unless @supress_output
      puts 'Instance Provisioning Complete' unless @supress_output
      return build_looper('instances') if @supress_output
      
    when 'list'
      abort('no list for ecosystems')
    when 'delete'
      delete_parser
    end
  end

  def create
    case @function
    when 'vcns'
      vcn = VcnClient.new
      vcn.options = @options
      vcn.instanceparameters = @instanceparameters
      vcn.create
    when 'internet_gateways'
      inst = InternetGateway.new
      inst.options = @options
      inst.instanceparameters = @instanceparameters
      inst.create
    when 'route_tables'
      inst = RouteClient.new
      inst.options = @options
      inst.instanceparameters = @instanceparameters
      inst.create
    when 'subnets'
      sub = SubnetClient.new
      sub.options = @options
      sub.instanceparameters = @instanceparameters
      sub.create
    when 'storage'
      bs = BmcBlockStorageClient.new
      bs.options = @options
      bs.instanceparameters = @instanceparameters
      bs.create
    when 'instances'
      inst = InstanceClient.new
      inst.options = @options
      inst.instanceparameters = @instanceparameters
      inst.create
    when 'security_lists'
      inst = SecurityListClient.new
      inst.options = @options
      inst.instanceparameters = @instanceparameters
      inst.create
    end
  end

  def delete_parser
    delete('compute', 'instances')
    delete('compute', 'storage')
    delete('network', 'subnets')
    delete('network', 'security_lists')
    delete('network', 'route_tables')
    sleep 9
    delete('network', 'vcns')
    
  end

  # this method is an orchestration method that calls other delete methods for various services
  def delete(container, function) # rubocop:disable Metrics/AbcSize
    instance_details = AttrFinder.new(@instanceparameters)
    instance_details.validate = @validate
    case function
    when 'subnets'
      asset = 'subnet'
    when 'vcns'
      asset = 'vcn'
    when 'instances'
      asset = 'server'
    when 'storage'
      asset = 'volume'
    when 'security_lists'
      asset = 'security_list'
    when 'route_tables'
      asset = 'route_table'
    when 'internet_gateways'
      asset = 'internet_gateway'
    end
    unless @instanceparameters[container].nil? || @instanceparameters[container].at(0)[function].nil?
      @instanceparameters[container].at(0)[function].each do |vols|
        @options[:inst] = vols[asset]['display_name']
        @options[:vcn] = vols[asset]['display_name'] if asset == 'vcn'
        @options[:vcn] = vols[asset]['vcn'] unless asset == 'vcn'
        instance_details.options = @options
        instance_details.function = asset
        bs = class_locator(function)
        bs.options = @options
        bs.instanceparameters = @instanceparameters
        bs.delete unless instance_details.public_send(asset).nil?
        puts 'deleted ' + @options[:inst] unless instance_details.public_send(asset).nil?
      end
    end
  end

  def class_locator(function)
    case function
    when 'storage'
      BmcBlockStorageClient.new
    when 'instances'
      InstanceClient.new
    when 'subnets'
      SubnetClient.new
    when 'vcns'
      VcnClient.new
    when 'security_lists'
      SecurityListClient.new
    when 'route_tables'
      RouteClient.new
    end
  end
end
