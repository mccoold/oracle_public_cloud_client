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

  def create
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: jasscreate.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain  }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-j', '--create_json JSON', 'json file to describe server') { |v| options[:create_json] = v }
      opts.on('-t', '--track', 'track status of build') { |track| options[:track] = track  }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end # end of method

  def inst_list
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-b', '--backup_id BACKUP_ID', 'backup ID') { |v| options[:backup_id] = v }
      opts.on('-m', '--managed [MANG]', 'flag for managed instances') { |v| options[:mang] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end.parse!
    options
  end # end of method

  def delete
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-I', '--inst INST', 'Instance name to be deleted') { |v| options[:inst] = v }
      opts.on('-c', '--config CONFIG', 'delete config JSON') { |v| options[:config] = v }
      opts.on('-D', '--dbuser DBUSER', 'DB username') { |v| options[:dbuser] = v }
      opts.on('-P', '--dbpass DBPASS', 'DB password') { |v| options[:dbpass] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method

  def storage_create
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-A', '--action ACTION', 'action options, stop, start, restart') { |v| options[:action] = v }
      opts.on('-C', '--container CONTAINER', 'Container Name') { |v| options[:container] = v }
      opts.on('-f', '--file_name FILE_NAME', 'file to upload') { |v| options[:file_name] = v }
      opts.on('--file_type FILE_TYPE', 'http file or application type') { |v| options[:file_type] = v }
      opts.on('--public_key PUBLIC_KEY', 'RSA Public Key file') { |v| options[:public_key] = v }
      opts.on('-O', '--object_name OBJECT_NAME', 'filena,e to create') { |v| options[:object_name] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method

  def jaas_manage
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-I', '--inst INST', 'Instance name') { |v| options[:inst] = v }
      opts.on('-T', '--timeout TIMEOUT', 'Instance name') { |v| options[:timeout] = v }
      opts.on('-n', '--cluster_name CLUSTER', 'cluster name') { |v| options[:cluster_id] = v }
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
  
  def compute
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: example.rb [options]'
      opts.on('-i', '--id_domain ID_DOMAIN', 'id domain') { |id_domain| options[:id_domain] = id_domain }
      opts.on('-u', '--user_name NAME', 'User name for account') { |v| options[:user_name] = v }
      opts.on('-p', '--passwd PASS', 'Password for account') { |v| options[:passwd] = v }
      opts.on('-R', '--rest_endpoint REST_ENDPOINT', 'Rest end point for compute') { |v| options[:rest_endpoint] = v }
      opts.on('-C', '--container CONTAINER', 'Management Container Name for object') { |v| options[:container] = v }
      opts.on('-A', '--action ACTION', 'action for the function, list or detail') { |v| options[:action] = v }
      opts.on('-j', '--create_json JSON', 'json file to describe server') { |v| options[:create_json] = v }
      opts.on("--update_list x,y,z", Array, "list of what fields to update field=value,field=value") do |list|
        options[:list] = list
      end
      # opts.on('-f', '--file_name FILE_NAME', 'file to upload') { |v| options[:file_name] = v }
      # opts.on('--file_type FILE_TYPE', 'http file or application type') { |v| options[:file_type] = v }
      # opts.on('--public_key PUBLIC_KEY', 'RSA Public Key file') { |v| options[:public_key] = v }
      # opts.on('-O', '--object_name OBJECT_NAME', 'The object you want to do something with') { |v| options[:object_name] = v }
      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end # end help
    end.parse!
    options
  end  # end of method
end   # end of class
