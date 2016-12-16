
#Author:: Daryn McCool (<mdaryn@hotmail.com>)
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
# limitations under the License
#
class SecAppClient < NimbulaClient
 # list functionality for security applications
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine    
 def list(options)  # rubocop:disable Metrics/AbcSize
   @util = Utilities.new
   networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
   case options[:action].downcase
   when 'list'
     networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container])
     @util.response_handler(networkconfig)
     puts JSON.pretty_generate(JSON.parse(networkconfig.body))
   when 'details'
     networkconfig = networkconfig.list(options[:rest_endpoint], options[:container])
     @util.response_handler(networkconfig)
     puts JSON.pretty_generate(JSON.parse(networkconfig.body))
   else
     abort('invalid entry for action, please use details or list')
   end
 end

 def modify(options) # rubocop:disable Metrics/AbcSize
   @util = Utilities.new
   networkconfig = SecApp.new(options[:id_domain], options[:user_name], options[:passwd])
   case options[:action].downcase
   when 'create'
     file = File.read(options[:create_json])
     update = JSON.parse(file)
     networkconfig = networkconfig.modify(options[:rest_endpoint], options[:action], update)
     @util.response_handler(networkconfig)
     puts JSON.pretty_generate(JSON.parse(networkconfig.body))
   when 'delete'
     networkconfig = networkconfig.modify(options[:rest_endpoint], options[:action], options[:container])
     @util.response_handler(networkconfig)
     puts 'deleted' if networkconfig.code == '204'
   else
     puts 'invalid entry for action, please use create or delete'
   end
 end
end

class SecAssocClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine  
  # list all security associations in a container
  def list(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecAssoc.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.list(options[:rest_endpoint], options[:container], options[:action])
      @util.response_handler(networkconfig)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end
  end

  # update functionality for Security Assoc
  def update(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    networkconfig = SecAssoc.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action]
    when 'update'
      key_sep = '='
      updates = Hash.new
      options[:list].each do |v|
        key_value = v.split(key_sep)
        updates[key_value.at(0)] = key_value.at(1)
      end # end of parsing through the update parameters
      networklist = networkconfig.list(options[:rest_endpoint], options[:container], options[:action])
      data = JSON.parse(networklist.body).first
      data1 = data.at(1)
      update = data1.at(0)
      updates.each do |k, v|
        update[k] = v
      end
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action])
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      puts 'invalid entry for action'
    end
  end
end

# class to manage IPLists in the nimbula API
class SecIPListClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine  
  # lists all IPLists
  def list(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecIPList.new(options)
      networkconfig = networkconfig.list(options[:action].downcase)
      @util.response_handler(networkconfig)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'invalid entry for action, please use details or list'
    end
  end

  # performs create and delete functions for seciplist
  def update(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    networkconfig = SecIPList.new(options)
    options = args unless caller[0][/`([^']*)'/, 1] == '<top (required)>' || caller[0][/`([^']*)'/, 1].nil?
    case options[:action]
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate.create_data = update
      networkupdate = networkconfig.update(options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      abort('invalid entry for action')
    end
  end
end

class SecListClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine  
  def list(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecList.new(options)
      networkconfig = networkconfig.list(options[:action])
      @util.response_handler(networkconfig)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      puts 'Invalid entry for action, please use details or list'
    end
  end

  # performs create and delete functions
  def update(options) # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    networkconfig = SecList.new(options)
    case options[:action]
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate.create_data = update
      networkupdate = networkconfig.update(options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      puts 'invalid entry for action'
    end
  end
end

class SecRuleClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine  
  # list functionality for nimbula security rules
  def list(options)  # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
      networkconfig = networkconfig.discover(options[:rest_endpoint], options[:container], options[:action])
      @util.response_handler(networkconfig)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      abort('invalid entry for action please use details or list')
    end
  end

  def update(options)  # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action]
    when 'update'
      #  parsing through the update parameters
      key_sep = '='
      updates = Hash.new
      options[:list].each do |v|
        key_value = v.split(key_sep)
        updates[key_value.at(0)] = key_value.at(1)
      end 
      networklist = networkconfig.list(options[:rest_endpoint], options[:container])
      data = JSON.parse(networklist.body).first
      data1 = data.at(1)
      update = data1.at(0)
      updates.each do |k, v|
        update[k] = v
      end
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      abort('invalid entry for action')
    end
  end
end

class IpNetworkClient < NimbulaClient
  def list(options)  # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    options[:action].downcase
    if options[:action] == 'list' || options[:action] == 'details'
      networkconfig = NimbulaNetwork.new(options)
      networkconfig = networkconfig.list
      @util.response_handler(networkconfig)
      puts JSON.pretty_generate(JSON.parse(networkconfig.body))
    else
      abort('invalid entry for action please use details or list')
    end
  end

  def update(options)  # rubocop:disable Metrics/AbcSize
    networkconfig = SecRule.new(options[:id_domain], options[:user_name], options[:passwd])
    case options[:action]
    when 'update'
      key_sep = '='
      updates = Hash.new
      options[:list].each do |v|
        key_value = v.split(key_sep)
        updates[key_value.at(0)] = key_value.at(1)
      end
      networklist = networkconfig.list(options[:rest_endpoint], options[:container])
      data = JSON.parse(networklist.body).first
      data1 = data.at(1)
      update = data1.at(0)
      updates.each do |k, v|
        update[k] = v
      end
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'create'
      file = File.read(options[:create_json])
      update = JSON.parse(file)
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action], update)
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    when 'delete'
      networkupdate = networkconfig.update(options[:rest_endpoint], options[:container], options[:action])
      @util.response_handler(networkupdate)
      JSON.pretty_generate(JSON.parse(networkupdate.body))
    else
      abort('invalid entry for action')
    end
  end
end

class IPUtilClient < NimbulaClient
#  def request_handler(args) # rubocop:disable Metrics/AbcSize
#    inputparse =  InputParse.new(args)
#    @options = inputparse.compute('iputil')
#    @util = Utilities.new
#    attrcheck = { 'Action' => @options[:action],
#                  'RestEndPoint' => @options[:rest_endpoint],
#                  'Function' => @options[:function]
#    }
#    @validate = Validator.new
#    @validate.attrvalidate(@options, attrcheck)
#    case @options[:action].downcase
#    when 'list', 'details'
#      list
#    when 'create'
#      create
#    when 'delete'
#      delete
#    when 'update'
#      update
#    else
#      abort('You entered an invalid selection for Action')
#    end
#    
#    @function = 'association' if @options[:function] == 'ip_association'
#    @function = 'reservation' if @options[:function] == 'ip_reservation'
#  end

  attr_writer :options, :function

  def list # rubocop:disable Metrics/AbcSize
    @util = Utilities.new
    @iputil = IPUtil.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    @validate = Validator.new
    @function = 'association' if @options[:function] == 'ip_association'
    @function = 'reservation' if @options[:function] == 'ip_reservation'
    attrcheck = { 'Container' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    networkconfig = @iputil.list(@options[:container], @options[:action], @function)
    @util.response_handler(networkconfig)
    return JSON.pretty_generate(JSON.parse(networkconfig.body))
  end

  def update # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Container' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    key_sep = '='
    updates = {}
    @options[:list].each do |v|
      key_value = v.split(key_sep)
      updates[key_value.at(0)] = key_value.at(1)
    end # end of parsing through the update parameters
    networklist = @iputil.list(@options[:container])
    data = JSON.parse(networklist.body).first
    data1 = data.at(1)
    update = data1.at(0)
    updates.each do |k, v|
      update[k] = v
    end
    networkupdate.create_json = update
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end

  def create
    file = File.read(@options[:create_json])
    update = JSON.parse(file)
    networkupdate.create_json = update
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end

  def delete
    networkupdate.ipcontainer_name = @options[:container]
    networkupdate = @iputil.update(@options[:action], @function)
    @util.response_handler(networkupdate)
    JSON.pretty_generate(JSON.parse(networkupdate.body))
  end
end