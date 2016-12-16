# class to access bmc network functionality
class VcnClient < BmcClient
  def initialize
    @validate = Validator.new
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptParsing

  attr_writer :options, :validate, :instanceparameters

  # list mehod for vcn in a compartment
  def list
    attrcheck = { 'compartment' => @options[:compartment] }
    @validate.validate(@options, attrcheck)
    opts = {}
    opts[:availability_domain] = @options[:availability_domain] if @options[:availability_domain]
    opts[:display_name] = @options[:vcn] if @options[:vcn]
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_vcns(@options[:compartment], opts)
    request.data
  end

  # create method for new vcn in a compartment
  def create
    BmcAuthenticate.new(@options)
    opts = {}
    instance_details = AttrFinder.new(@instanceparameters)
    instance_details.options = @options
    instance_details.validate = @validate
    instance_details.function = 'vcn'
    instance_details.vcn # This is only here because the SDK can not establish a connection with POST
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    vcn_details = OracleBMC::Core::Models::CreateVcnDetails.new
    vcn_details.cidr_block = @instanceparameters['vcn']['cidr_block']
    vcn_details.compartment_id = instance_details.compartment
    vcn_details.display_name = @instanceparameters['vcn']['display_name']
    vcnapi.create_vcn(vcn_details, opts)
  end

  def delete
    vcn_attr = AttrFinder.new(@instanceparameters)
    vcn_attr.options = @options
    vcn_attr.validate = @validate
    vcn_attr.function = 'vcn'
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_vcn(vcn_attr.vcn, opts)
    # puts vcn_attr.vcn
    return 'VCN deleted'
  end
end

# client class for all Security list functionality in the next gen cloud
class SecurityListClient
  def initialize
    @validate = Validator.new
    @action = 'securitylists'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing
  attr_writer :options, :validate, :instanceparameters

  def list(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_security_lists(@options[:compartment], vcn_id, opts)
    request.data
  end

  def create # rubocop:disable Metrics/AbcSize
    BmcAuthenticate.new(@options)
    sl_attr = AttrFinder.new(@instanceparameters)
    sl_attr.options = @options
    sl_attr.validate = @validate
    sl_attr.function = 'security_list'
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    sl_details = OracleBMC::Core::Models::CreateSecurityListDetails.new
    sl_details.compartment_id = sl_attr.compartment
    sl_details.vcn_id = sl_attr.vcn
    sl_details.ingress_security_rules = Array.new
    sl_details.egress_security_rules = Array.new
    sl_details.display_name = @instanceparameters['security_list']['display_name']
    @instanceparameters['security_list']['ingress_rules'].each do |rule|
      ingress_rule = OracleBMC::Core::Models::IngressSecurityRule.new
      ingress_rule.protocol = rule['rule']['protocol']
      ingress_rule.source = rule['rule']['source']
      ports = OracleBMC::Core::Models::TcpOptions.new
      portRange = OracleBMC::Core::Models::PortRange.new
      portRange.min = rule['rule']['min_port']
      portRange.max = rule['rule']['max_port']
      ports.destination_port_range = portRange
      ingress_rule.tcp_options = ports
      sl_details.ingress_security_rules.push(ingress_rule)
    end
    @instanceparameters['security_list']['egress_rules'].each do |rule|
      egress_rule = OracleBMC::Core::Models::EgressSecurityRule.new
      egress_rule.protocol = rule['rule']['protocol']
      egress_rule.destination = rule['rule']['destination']
      sl_details.egress_security_rules.push(egress_rule)
    end
    return vcnapi.create_security_list(sl_details)
  end
  
  def delete
    security_list_attr = AttrFinder.new(nil)
    security_list_attr.options = @options
    security_list_attr.validate = @validate
    security_list_attr.function = 'security list'
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_security_list(security_list_attr.security_list, opts)
    return 'security list deleted'
    end
end

# client class for all DHCP option functionality
class DHCPClient < BmcClient
  def initialize
    @validate = Validator.new
    @action = 'dhcp_options'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing
  attr_writer :options, :validate, :instanceparameters

  def list(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_dhcp_options(@options[:compartment], vcn_id, opts)
    request.data
  end

  def create
    BmcAuthenticate.new(@options)
    dhcp_attr = AttrFinder.new(@instanceparameters)
    dhcp_attr.options = @options
    dhcp_attr.validate = @validate
    dhcp_attr.function = 'dhcp_options'
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    dhcp_details = OracleBMC::Core::Models::CreateDhcpDetails.new
    dhcp_details.compartment_id = dhcp_attr.compartment
    dhcp_details.vcn_id = dhcp_attr.vcn
    dhcp_details.display_name = @instanceparameters['dhcp_options']['display_name']
    vcnapi.create_dhcp_options(dhcp_details)
  end

  # deletes DHCP option in a VCN
  def delete
    dhcp_attr = AttrFinder.new(@instanceparameters)
    dhcp_attr.options = @options
    dhcp_attr.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_dhcp_options(dhcp_attr.dhcp, opts)
    return 'dhcp deleted'
  end
end

# client class for all route table functionality
class RouteClient < BmcClient
  def initialize
    @validate = Validator.new
    @action = 'route_tables'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing
  attr_writer :options, :validate, :instanceparameters

  # list route tables
  def list(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_route_tables(@options[:compartment], vcn_id, opts)
    request.data
  end

  # deletes route tables
  def delete
    route_table_attr = AttrFinder.new(@instanceparameters)
    route_table_attr.options = @options
    route_table_attr.validate = @validate
    route_table_attr.function = 'route_table'
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_route_table(route_table_attr.route, opts)
    return 'route deleted'
  end

  # creates route tables
  def create # rubocop:disable Metrics/AbcSize
    BmcAuthenticate.new(@options)
    route_table_attr = AttrFinder.new(@instanceparameters)
    route_table_attr.options = @options
    route_table_attr.validate = @validate
    route_table_attr.function = 'route_table'
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    route_details = OracleBMC::Core::Models::CreateRouteTableDetails.new
    route_details.compartment_id = route_table_attr.compartment
    route_details.route_rules = Array.new
    route_table_attr.param = 'internet_gateway'
    @instanceparameters['route_table']['route_rules'].each do |route_rule|
      route_rule_details = OracleBMC::Core::Models::RouteRule.new
      route_rule_details.cidr_block = route_rule['route_rule']['cidr_block']
      route_rule_details.network_entity_id = route_table_attr.internet_gateway
      route_details.route_rules.push(route_rule_details)
    end
    route_details.vcn_id = route_table_attr.vcn
    route_details.display_name = @instanceparameters['route_table']['display_name']
    vcnapi.create_route_table(route_details)
  end
end

# client class for subnets
class SubnetClient < BmcClient
  def initialize
    @validate = Validator.new
    @action = 'subnets'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing

  attr_writer :options, :validate, :instanceparameters

  # create menthod for creating a new subnet in a vcn
  def create # rubocop:disable Metrics/AbcSize
    BmcAuthenticate.new(@options)
    subnet_attr = AttrFinder.new(@instanceparameters)
    subnet_attr.options = @options
    subnet_attr.validate = @validate
    subnet_attr.function = 'subnet'
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    subnet_details = OracleBMC::Core::Models::CreateSubnetDetails.new
    subnet_details.cidr_block = @instanceparameters['subnet']['cidr_block']
    subnet_details.compartment_id = subnet_attr.compartment
    subnet_details.availability_domain = subnet_attr.ad
    subnet_details.vcn_id = subnet_attr.vcn
    subnet_attr.param = 'security_list'
    subnet_details.security_list_ids = Array.new
    subnet_details.security_list_ids.push(subnet_attr.security_list)
    subnet_attr.param = 'route_table'
    subnet_details.route_table_id = subnet_attr.route_table
    subnet_details.display_name = @instanceparameters['subnet']['display_name']
    vcnapi.create_subnet(subnet_details)
  end

  # deletes subnets in a VCN
  def delete
    attrcheck = { 'vcn' => @options[:vcn] }
    @validate.validate(@options, attrcheck)
    subnet_attr = AttrFinder.new(@instanceparameters)
    subnet_attr.options = @options
    subnet_attr.validate = @validate
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_subnet(subnet_attr.subnet, opts)
    return 'subnet ' + @options[:inst] + ' deleted'
  end

  # list all subnets in a VCN
  def list(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_subnets(@options[:compartment], vcn_id, opts)
    request.data
  end
end

# class for managing internet gateway
class InternetGateway < BmcClient
  def initialize
    @validate = Validator.new
    @action = 'internet_gateways'
  end

  require 'opc_client/bmc/helpers'
  include BmcHelpers::CommandLine
  include BmcHelpers::OptionParsing
  attr_writer :options, :validate, :instanceparameters

  # creates internet gateway
  def create
    internet_gateway_attr = AttrFinder.new(@instanceparameters)
    internet_gateway_attr.options = @options
    internet_gateway_attr.validate = @validate
    internet_gateway_attr.function = 'internet_gateway'
    BmcAuthenticate.new(@options)
    vcnapi = OracleBMC::Core::VirtualNetworkClient.new
    internet_gateway_details = OracleBMC::Core::Models::CreateInternetGatewayDetails.new
    internet_gateway_details.display_name = @instanceparameters['internet_gateway']['display_name']
    internet_gateway_details.vcn_id = internet_gateway_attr.vcn
    internet_gateway_details.is_enabled = @instanceparameters['internet_gateway']['enabled']
    internet_gateway_details.compartment_id = internet_gateway_attr.compartment
    vcnapi.create_internet_gateway(internet_gateway_details)
  end

  # delete functionality for gateways, must pass vcn display name and display name of the gateway
  def delete
    internet_gateway_attr = AttrFinder.new(@instanceparameters)
    internet_gateway_attr.options = @options
    internet_gateway_attr.validate = @validate
    internet_gateway_attr.function = 'internet_gateway'
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::VirtualNetworkClient.new
    request.delete_internet_gateway(internet_gateway_attr.gateway, opts)
    return 'gateway deleted'
  end

  # lists all the internet gateways in a vcn
  def list(vcn_id)
    opts = {}
    request = OracleBMC::Core::VirtualNetworkClient.new
    request = request.list_internet_gateways(@options[:compartment], vcn_id, opts)
    request.data
  end
end
