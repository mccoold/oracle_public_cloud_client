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
class InputParse < OpcClient
  #
  def initialize(args)
    @args = args
  end

  def create # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: opccreate.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain  }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-S', '--service SERVICE', 'Service to manage') { |v| options[:function] = v }
      opts.on('-j', '--create_json JSON', 'json file to describe server') { |v| options[:create_json] = v }
      opts.on('-t', '--track', 'track status of build') { |track| options[:track] = track  }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end # end of method

  def inst_list(caller) # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-s', '--server SERVERID', 'server to be scaled in') { |v| options[:serverid] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-A', '--action ACTION', 'action options') { |v| options[:action] = v } unless caller == 'bkup'
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      options[:mang] = 'false'
      opts.on('-m', '--managed', 'flag for managed instances') { |v| options[:mang] = 'true' }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end # end of method

  def delete # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-A', '--action ACTION', 'action options, jcs, dbcs, soa') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name to be deleted') { |v| options[:inst] = v }
      opts.on('-c', '--config CONFIG', 'delete config JSON, for jsc only') { |v| options[:config] = v }
      opts.on('-D', '--dbuser DBUSER', 'DB username, for dbcs only') { |v| options[:dbuser] = v }
      opts.on('-P', '--dbpass DBPASS', 'DB password, for dbcs only') { |v| options[:dbpass] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method

  def storage_create # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-C', '--container CONTAINER', 'Container Name') { |v| options[:container] = v }
      opts.on('-f', '--file_name FILE_NAME', 'file to upload') { |v| options[:file_name] = v }
      opts.on('--file_type FILE_TYPE', 'http file or application type') { |v| options[:file_type] = v }
      opts.on('--public_key PUBLIC_KEY', 'RSA Public Key file') { |v| options[:public_key] = v }
      opts.on('-O', '--object_name OBJECT_NAME', 'filename to create') { |v| options[:object_name] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method

  def manage # rubocop:disable Metrics/AbcSize
    options = {}
    
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point') { |v| options[:rest_endpoint] = v }
      opts.on('-S', '--service SERVICE', 'Service to manage') { |v| options[:function] = v }
      opts.on('-T', '--timeout TIMEOUT', 'Instance name') { |v| options[:timeout] = v }
      options[:mang] = 'false'
      opts.on('-m', '--managed', 'flag for managed instances') do options[:mang] = 'true'  end
      opts.on('-n', '--cluster_name CLUSTER', 'cluster name') { |v| options[:cluster_id] = v }
      opts.on('-t', '--track', 'track status of build') { |track| options[:track] = track  }
      opts.on('--patch_id PATCH_ID', 'patch id') { |v| options[:patch_id] = v }
      opts.on('-j', '--create_json JSON', 'json file to describe server') { |v| options[:create_json] = v }
      opts.on('-s', '--server SERVERID', 'server to be scaled in') { |v| options[:serverid] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end # end of method

  def compute(caller) # rubocop:disable Metrics/AbcSize
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point for compute') { |v| options[:rest_endpoint] = v }
      opts.on('-C', '--container CONTAINER', 'Management Container Name for object') { |v| options[:container] = v }
      opts.on('-F', '--function FUNCTION', 'Management Container Name for object') { |v| options[:function] = v } if caller == 'networklist'
      opts.on('-A', '--action ACTION', 'action for the function, list or detail') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v } if caller == 'orch' || caller == 'compute'
      opts.on('-j', '--create_json JSON', 'json file to describe server') { |v| options[:create_json] = v }
      opts.on('--update_list x,y,z', Array, 'list of what fields to update field=value,field=value') do |list|
        options[:list] = list
      end
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method
end   # end of class
