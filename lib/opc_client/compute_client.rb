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
class ComputeClient < OpcClient
  def request_handler(args) # rubocop:disable Metrics/AbcSize
    inputparse =  InputParse.new(args)
    @options = inputparse.compute('compute')
    @util = Utilities.new
    attrcheck = { 'Action'  => @options[:action],
                  'Service' => @options[:function] 
    }
    @validate = Validator.new
    @validate.attrvalidate(@options, attrcheck)
    case @options[:function].downcase
    when 'block_storage', 'snap_storage'
      bstorage = BlockStorageClient.new
      bstorage.options = @options
      bstorage.option_parse
    when 'instance', 'snapshot'
      option_parse
    else
      abort('you did not select a valid Service')
    end
  end
  
  def option_parse
    case @options[:action].downcase
    when 'list', 'details'
      list
    when 'imagelist_list'
      image_list
    when 'delete'
      delete
    when 'shape_list'
      shape_list
    when 'list_ip'
      list_ip
    when 'imagelist_create'
      image_create
    when 'machineimage_create'
      machineimage_create
    when 'machineimage_list', 'machineimage_details'
      machineimage_list
    when 'create'
      abort('create only for snapshot') unless @options[:function].downcase == 'snapshot'
      create_snap
    else
      abort('You entered an invalid selection for Action, the options are : machineimage_list, machineimage_create,
       list_ip, list, details, delete')
    end # end case
  end # end method

  attr_writer :options, :util

  def list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container] }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Instance.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig.function = '/snapshot' if @options[:function].downcase == 'snapshot'
    instanceconfig = instanceconfig.list(@options[:container], @options[:action])
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def image_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = ImageList.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.list(@options[:container])
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def image_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Create JSON'       => @options[:create_json]
    }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    instanceconfig = ImageList.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.create(create_data)
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def machineimage_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = MachineImage.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.list(@options[:container], 'list') if @options[:action] == 'machineimage_list'
    instanceconfig = instanceconfig.list(@options[:container], 'details') if @options[:action] == 'machineimage_details'
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def machineimage_create # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Create JSON'       => @options[:create_json]
    }
    @validate.attrvalidate(@options, attrcheck)
    file = File.read(@options[:create_json])
    create_data = JSON.parse(file)
    instanceconfig = MachineImage.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.create(create_data)
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def delete # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instance = Instance.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instancedelete = instance.delete(@options[:container])
    @util.response_handler(instancedelete)
    puts 'deleted' if instancedelete.code == '204'
  end # end of method

  def shape_list # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Shape.new(@options[:id_domain], @options[:user_name], @options[:passwd])
    instanceconfig = instanceconfig.list(@options[:rest_endpoint], @options[:container])
    @util.response_handler(instanceconfig)
    return JSON.pretty_generate(JSON.parse(instanceconfig.body))
  end # end of method

  def list_ip # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    instanceconfig = Instance.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instanceconfig = instanceconfig.list_ip(@options[:container])
    @util.response_handler(instanceconfig)
    return 'the internal IP address is ' + instanceconfig[0] + ' and the external IP address is ' + instanceconfig[1]
  end # end of method
  
  def create_snap # rubocop:disable Metrics/AbcSize
    attrcheck = {
      'REST end point'  => @options[:rest_endpoint],
      'Container'       => @options[:container]
    }
    @validate.attrvalidate(@options, attrcheck)
    puts 'in snap'
    instance = Instance.new(@options[:id_domain], @options[:user_name], @options[:passwd], @options[:rest_endpoint])
    instance.function = '/snapshot/'
    instance.machine_image = @options[:inst] if @options[:inst]
    instancesnap = instance.create_snap(@options[:container])
    @util.response_handler(instancesnap)
    return JSON.pretty_generate(JSON.parse(instancesnap.body))
  end # end of method
end # end of class
