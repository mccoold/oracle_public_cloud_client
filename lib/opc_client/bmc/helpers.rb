class BmcHelpers < BmcClient
  module CommandLine
    def request_handler(args)    
      inputparse =  BmcInputParser.new(args)
      @options = inputparse.bmc('vncclient')
      if @options[:yaml]
        @instanceparameters = yaml_reader(@options[:yaml])
      elsif @options[:json]
        @instnaceparameters = json_reader
      end
      attrcheck = {
        'fingerprint'   => @options[:fingerprint],
        'tenancy'       => @options[:tenancy],
        'key_file'      => @options[:key_file]
      }
      @validate.validate(@options, attrcheck)
      opt_parse
    end

    attr_writer :action, :supress_output
    
    def delete_validator
      attrcheck = { 'vnc' => @options[:vcn] }
      @validate.validate(@options, attrcheck)
      delete
    end
    
    # reading in yaml 
    def yaml_reader(file)
      YAML.load(File.read(file))
    end

    # handles the return objects from the bmc SDK
    def formatter(response)
      outid = {}
      if response.is_a?(Array)
        response.each do |out|
          out = out.to_hash
          outid = out
          outid = outid.to_json
          puts JSON.pretty_generate(JSON.parse(outid))
          return outid
        end
      else
        response = response.to_json
        puts JSON.pretty_generate(JSON.parse(response))
        return response
      end
    end

    def build_looper(function) # rubocop:disable Metrics/AbcSize
      @function = function
      case function
      when 'subnets'
        parent = 'network'
        asset = 'subnet'
      when 'vcns'
        parent = 'network'
        asset = 'vcn'
      when 'instances'
        parent = 'compute'
        asset = 'server'
      when 'storage'
        parent = 'compute'
        asset = 'volume'
      when 'security_lists'
        parent = 'network'
        asset = 'security_list'
      when 'internet_gateways'
        parent = 'network'
        asset = 'internet_gateway'
      when 'route_tables'
        parent = 'network'
        asset = 'route_table'
      end
      unless @instanceparameters[parent].nil?
        vcns = @instanceparameters[parent].at(0)
        vcns[function].each do |item|
          @options[:inst] = item[asset]['display_name']
          @options[:vcn] = item[asset]['display_name'] if asset == 'vcn'
          @options[:vcn] = item[asset]['vcn'] unless asset == 'vcn'
          inst_details = AttrFinder.new(@instanceparameters)
          inst_details.options = @options
          inst_details.validate = @validate
          inst_details.function = asset
          if inst_details.public_send(asset).nil?
            @instanceparameters = item
            formatter(create.data.to_hash)
          else
            puts 'Skipped ' + @options[:inst] + ' because it already exists ' unless @supress_output && function == 'instance'
            abort('instance already exists') if function == 'instance'
          end
        end
      end
    end

    def printip
      instanceip = list_instance_ip(inst.compartment, @instance_id)
      puts 'Success!! Server Is Available - Public Ip: ' + instanceip.at(1) + ' and Private Ip: ' +
           instanceip.at(0)
    end
  end

  # opt parsing for most services that are not top level in the yaml
  module OptionParsing
    def opt_parse
      vcnlient = VcnClient.new
      vcnlient.options = @options
      vcnlient.validate = @validate
      case @options[:action]
      when 'list'
        vcnlient.list.each do |vcn|
          formatter(list(vcn.id))
        end
      when 'create'
        build_looper(@action)
      when 'delete'
        puts delete_validator
      end
    end
  end

  # this module deal with lists that will not be arrays
  module OptParsing
    def opt_parse
      vcnlient = VcnClient.new
      vcnlient.options = @options
      vcnlient.validate = @validate
      case @options[:action]
      when 'list'
        formatter(list)
      when 'create'
        build_looper(@action)
      when 'delete'
        puts delete
      end
    end
  end
end
