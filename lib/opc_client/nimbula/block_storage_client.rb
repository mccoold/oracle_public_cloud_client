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
# limitations under the License
#
# client to manage block storage on the Nimbula cloud
class BlockStorageClient < NimbulaClient
  require 'opc_client/nimbula/helpers'
  include NimbulaHelpers::NimCommandLine
  
  def intialize
    @util = Utilities.new
    @validate = Validator.new
  end

  # parses action option to determine the correct method to be called for the request
  def option_parse
    attrcheck = {
      'Action'         => @options[:action],
      'REST endpoint'  => @options[:rest_endpoint]
    }
    @validate.attrvalidate(@options, attrcheck)
    case @options[:action].downcase
    when 'create'
      update
    when 'list', 'details'
      list
    when 'delete'
      update
    else
      abort('you entered an invalid selection for Action')
    end
  end

  attr_writer :options
  
  # list method for block storage
  def list # rubocop:disable Metrics/AbcSize
    attrcheck = { 'Container' => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    @options[:action].downcase
    if @options[:action] == 'list' || @options[:action] == 'details'
      storageconfig = BlockStorage.new(@options)
      storageconfig.function = @options[:function]
      storageconfig = storageconfig.list(@options[:action])
      @util.response_handler(storageconfig)
      return JSON.pretty_generate(JSON.parse(storageconfig.body))
    else
      abort('Invalid entry for action, please use details or list')
    end
  end

  # management method for block storage handles CRUD operations
  def update # rubocop:disable Metrics/AbcSize
    storageconfig = BlockStorage.new(@options[:id_domain], @options[:user_name], @options[:passwd],
                                     @options[:rest_endpoint])
    case @options[:action].downcase
    when 'create'
      attrcheck = { 'create_json' => @options[:create_json] }
      @validate.attrvalidate(@options, attrcheck)
      file = File.read(@options[:create_json])
      storageconfig.create_parms = JSON.parse(file)
      storageconfig.function = @options[:function] if @options[:function] == 'volume_snapshot'
      storageupdate = storageconfig.update(@options[:action])
      @util.response_handler(storageupdate)
      JSON.pretty_generate(JSON.parse(storageupdate.body))
    when 'delete'
      attrcheck = { 'Container' => @options[:container] }
      @validate.attrvalidate(@options, attrcheck)
      storageconfig.container = @options[:container]
      storageupdate = storageconfig.update(@options[:action])
      @util.response_handler(storageupdate)
      return 'storage volume ' + @options[:container] + ' has been deleted' if storageupdate.code == '204'
    when 'update'
      attrcheck = { 'create_json' => @options[:create_json],
                    'Container'   => @options[:container] }
      @validate.attrvalidate(@options, attrcheck)
      file = File.read(@options[:create_json])
      update = JSON.parse(file)
      abort('this functionality is not for snapshot') if @options[:function] == 'volume_snapshot'
      storageconfig.container = @options[:container]
      storageupdate = storageconfig.update(@options[:action])
      @util.response_handler(storageupdate)
      JSON.pretty_generate(JSON.parse(storageupdate.body))
    else
      abort('invalid entry')
    end
  end
end
