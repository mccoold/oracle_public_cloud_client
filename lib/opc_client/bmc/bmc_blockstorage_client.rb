class BmcBlockStorageClient < BmcClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  BmcInputParser.new(args)
    @options = inputparse.bmc('instanceclient')
    attrcheck = { 'fingerprint'       => @options[:fingerprint],
                  'tenancy'        => @options[:tenancy],
                  'key_file'  => @options[:key_file]
                  # 'Container'     => @options[:container] 
    }
    if @options[:yaml]
      @instanceparameters = inputparse.yaml_reader(@options[:yaml])
    elsif @options[:json]
      @instnaceparameters = json_reader
    end
    @validate = Validator.new
    @validate.validate(@options, attrcheck)
    case @options[:action]
    when 'create'
      
#      puts @instanceparameters
#      puts 'next'
      @instanceparameters = @instanceparameters['storage'].at(0)
#        puts @instanceparameters
      create
    when 'list'
      inputparse.formatter(list)
    when 'delete'
      delete
    end
  end

  # create new storage volumes on the Oracle Next Gen cloud
  def create
    instance_details = AttrFinder.new(@instanceparameters)
    instance_details.options=(@options)
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
    response = api.get_volume(instance_id).wait_until(:lifecycle_state, OracleBMC::Core::Models::Volume::LIFECYCLE_STATE_RUNNING)
  end
    
  def list
    attrcheck = {'compartment' => @options[:compartment]}
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
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Core::BlockstorageClient.new
    request.delete_volume(@options[:inst], opts)
    end
end