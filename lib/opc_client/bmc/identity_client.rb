class IdentityClient < BmcClient
  # Request Handler is for command line calls
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  BmcInputParser.new(args)
    @options = inputparse.bmc('vncclient')
    attrcheck = { 'fingerprint'  => @options[:fingerprint],
                  'tenancy'      => @options[:tenancy],
                  'key_file'     => @options[:key_file] 
    }
    @validate = Validator.new
    @validate.validate(@options, attrcheck)
    case @options[:action]
    when 'create'
      create
    when 'list'
      list
    when 'delete'
      delete
    end
  end
    
  attr_writer :options, :validate
  
  def ad_list
    opts = {}
    BmcAuthenticate.new(@options)
    request = OracleBMC::Identity::IdentityClient.new
    request = request.list_availability_domains(@options[:compartment], opts)
    request.data
  end
end