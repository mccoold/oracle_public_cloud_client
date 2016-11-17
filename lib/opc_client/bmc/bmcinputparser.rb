# Author:: Daryn McCool (<mdaryn@hotmail.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.class OPC
#
class BmcInputParser < BmcClient
  def initialize(args)
    @args = args
    @util = Utilities.new
  end
  
  def bmc(caller) # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('--tenancy TENANCY', 'tenancy for account') { |id_domain| options[:tenancy] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('--fingerprint FINGERPRINT', 'fingerprint for account') { |v| options[:fingerprint] = v }
      opts.on('-s', '--server SERVERID', 'server to be scaled in') { |v| options[:serverid] = v }
      opts.on('--key_file KEY', 'key file for tenant') { |v| options[:key_file] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-A', '--action ACTION', 'action options') { |v| options[:action] = v } unless caller == 'bkup'
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-Y', '--yaml YAML', 'YAML file') { |v| options[:yaml] = v }
      opts.on('--display_name DISP', 'Instance display name') { |v| options[:display_name] = v }
      opts.on('--availability_domain AD', 'Availability Domain') { |v| options[:availability_domain] = v }
      opts.on('-S', '--service SERVICE', 'Service to manage') { |v| options[:function] = v }
      opts.on('-C', '--compartment COMP', 'compartment') { |v| options[:compartment] =v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    @util.config_file_reader(options)
    options
  end # end of method
  
  def yaml_reader(file)
    env = YAML.load(File.read(file))
    end
  # handles the return objects from the bmc SDK
  def formatter(resonseObject)
    outid = {}
    resonseObject.each do |out|
      out = out.to_hash
      outid = out
      outid = outid.to_json
      outid = JSON.pretty_generate(JSON.parse(outid))
     # JSON.pretty_generate(JSON.parse(out)) 
      puts outid # needs to be deleted only here because list subnet not workings as it should
    end
   outid
  end
end
